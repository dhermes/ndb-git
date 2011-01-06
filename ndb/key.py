"""Key class and associated stuff.

TODO: docstrings, style
"""

import base64
import os

from google.appengine.api import namespace_manager
from google.appengine.datastore import datastore_rpc
from google.appengine.datastore import entity_pb

positional = datastore_rpc._positional

class Key(object):
  """An immutable datastore key.

  Long constructor forms:
    Key(pairs=[(kind, idorname), (kind, idorname), ...])
    Key(flat=[kind, idorname, kind, idorname, ...])
    Key(reference=<reference>)
    Key(serialized=<serialized reference>)
    Key(urlsafe=<urlsafe base64 encoded serialized reference>)

  Short constructor form:
    Key(kind, idorname, ...)  # Same as Key(flat=[kind, idorname, ...])

  Backdoor constructor form:
    Key(<dict>)  # If X is a dict, Key(X) == Key(**X)

  Other keyword arguments:
    Key(..., app=<appid>, namespace=<namespace>, parent=<key>)
    # Override app id, namespace, parent key.
  """

  __slots__ = ['__reference']

  def __new__(cls, *_args, **kwargs):
    if _args:
      if len(_args) == 1 and isinstance(_args[0], dict):
        # For pickling only: one positional argument is allowed,
        # giving a dict specifying the keyword arguments.
        assert not kwargs
        kwargs = _args[0]
      else:
        assert 'flat' not in kwargs
        kwargs['flat'] = _args
    self = super(Key, cls).__new__(cls)
    self.__reference = _ConstructReference(cls, **kwargs)
    return self

  def __repr__(self):
    args = []
    for item in self._flat():
      if isinstance(item, basestring):
        assert isinstance(item, str)  # No unicode should make it here.
        args.append(repr(item))
      else:
        args.append(str(item))
    if self.app() != _DefaultAppId():
      args.append('app=%r' % self.app())
    if self.namespace() != _DefaultNamespace():
      args.append('namespace=%r' % self.namespace())
    return 'Key(%s)' % ', '.join(args)

  __str__ = __repr__

  def __hash__(self):
    return hash(tuple(self._pairs()))

  def __eq__(self, other):
    if not isinstance(other, Key):
      return NotImplemented
    return (tuple(self._pairs()) == tuple(other._pairs()) and
            self.app() == other.app() and
            self.namespace() == other.namespace())

  def __ne__(self, other):
    if not isinstance(other, Key):
      return NotImplemented
    return not self.__eq__(other)

  def __getstate__(self):
    return ({'pairs': tuple(self._pairs()),
             'app': self.app(),
             'namespace': self.namespace()},)

  def __setstate__(self, state):
    assert len(state) == 1
    kwargs = state[0]
    assert isinstance(kwargs, dict)
    self.__reference = _ConstructReference(self.__class__, **kwargs)

  def __getnewargs__(self):
    return ({'pairs': tuple(self._pairs()),
             'app': self.app(),
             'namespace': self.namespace()},)

  def namespace(self):
    return self.__reference.name_space()

  def app(self):
    return self.__reference.app()

  def pairs(self):
    return list(self._pairs())

  def _pairs(self):
    for elem in self.__reference.path().element_list():
      kind = elem.type()
      if elem.has_id():
        idorname = elem.id()
      else:
        idorname = elem.name()
      yield (kind, idorname)

  def flat(self):
    return list(self._flat())

  def _flat(self):
    for kind, idorname in self._pairs():
      yield kind
      yield idorname

  def kind(self):
    kind = None
    for elem in self.__reference.path().element_list():
      kind = elem.type()
    return kind

  def reference(self):
    return _ReferenceFromReference(self.__reference)

  def _reference(self):
    # Backdoor to access self.__reference without copying.
    # The caller should not mutate the return value.
    return self.__reference

  def serialized(self):
    return self.__reference.Encode()

  def urlsafe(self):
    # This is 3-4x faster than urlsafe_b64decode()
    urlsafe = base64.b64encode(self.__reference.Encode())
    return urlsafe.rstrip('=').replace('+', '-').replace('/', '_')

  # Datastore API using the default context.
  # These use local import since otherwise they'd be recursive imports.

  def get(self):
    return self.get_async().get_result()

  def get_async(self):
    from ndb import tasklets
    return tasklets.get_context().get(self)

  def delete(self):
    return self.delete_async().get_result()

  def delete_async(self):
    from ndb import tasklets
    return tasklets.get_context().delete(self)

@positional(1)
def _ConstructReference(cls, pairs=None, flat=None,
                        reference=None, serialized=None, urlsafe=None,
                        app=None, namespace=None, parent=None):
  assert cls is Key
  howmany = (bool(pairs) + bool(flat) +
             bool(reference) + bool(serialized) + bool(urlsafe))
  assert howmany == 1
  if flat or pairs:
    if flat:
      assert len(flat) % 2 == 0
      pairs = [(flat[i], flat[i+1]) for i in xrange(0, len(flat), 2)]
    assert pairs
    if parent is not None:
      pairs[:0] = parent.pairs()
      if app:
        assert app == parent.app(), (app, parent.app())
      if namespace is not None:
        assert namespace == parent.namespace(), (namespace,
                                                 parent.namespace())
    reference = _ReferenceFromPairs(pairs)
    # An empty app id means to use the default app id.
    if not app:
      app = _DefaultAppId()
    # Always set the app id, since it is mandatory.
    reference.set_app(app)
    # An empty namespace overrides the default namespace.
    if namespace is None:
      namespace = _DefaultNamespace()
    # Only set the namespace if it is not empty.
    if namespace:
      reference.set_name_space(namespace)
  else:
    # You can't combine parent= with reference=, serialized= or urlsafe=.
    assert parent is None
    if urlsafe:
      serialized = _DecodeUrlSafe(urlsafe)
    if serialized:
      reference = _ReferenceFromSerialized(serialized)
    assert reference.path().element_size()
    # TODO: assert that each element has a type and either an id or a name
    if not serialized:
      reference = _ReferenceFromReference(reference)
    # You needn't specify app= or namespace= together with reference=,
    # serialized= or urlsafe=, but if you do, their values must match
    # what is already in the reference.
    if app is not None:
      assert app == reference.app(), (app, reference.app())
    if namespace is not None:
      assert namespace == reference.name_space(), (namespace,
                                                   reference.name_space())
  return reference

def _ReferenceFromPairs(pairs, reference=None):
  if reference is None:
    reference = entity_pb.Reference()
  path = reference.mutable_path()
  last = False
  for kind, idorname in pairs:
    assert not last, 'incomplete entry must be last'
    assert isinstance(kind, basestring)
    if isinstance(kind, unicode):
      kind = kind.encode('utf8')
    assert 1 <= len(kind) <= 500
    elem = path.add_element()
    elem.set_type(kind)
    if isinstance(idorname, (int, long)):
      assert 1 <= idorname < 2**63
      elem.set_id(idorname)
    elif isinstance(idorname, basestring):
      if isinstance(idorname, unicode):
        idorname = idorname.encode('utf8')
      assert 1 <= len(idorname) <= 500
      elem.set_name(idorname)
    elif idorname is None:
      elem.set_id(0)
      last = True
    else:
      assert False, 'bad idorname (%r)' % (idorname,)
  return reference

def _ReferenceFromReference(reference):
  new_reference = entity_pb.Reference()
  new_reference.CopyFrom(reference)
  return new_reference

def _ReferenceFromSerialized(serialized):
  assert isinstance(serialized, basestring)
  if isinstance(serialized, unicode):
    serialized = serialized.encode('utf8')
  return entity_pb.Reference(serialized)

def _DecodeUrlSafe(urlsafe):
  assert isinstance(urlsafe, basestring)
  if isinstance(urlsafe, unicode):
    urlsafe = urlsafe.encode('utf8')
  mod = len(urlsafe) % 4
  if mod:
    urlsafe += '=' * (4 - mod)
  # This is 3-4x faster than urlsafe_b64decode()
  return base64.b64decode(urlsafe.replace('-', '+').replace('_', '/'))

def _DefaultAppId():
  return os.getenv('APPLICATION_ID', '_')

def _DefaultNamespace():
  return namespace_manager.get_namespace()
