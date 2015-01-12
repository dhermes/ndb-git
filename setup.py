from setuptools import setup
from setuptools import find_packages


REQUIREMENTS = [
]

setup(
    name='ndb',
    version='0.0.1',
    description='Google App Engine NDB',
    author='Alfred Fuller',
    author_email='arfuller@google.com',
    scripts=[],
    url='https://github.com/dhermes/ndb-git',
    packages=find_packages(),
    license='Apache 2.0',
    platforms='Posix; MacOS X; Windows',
    include_package_data=True,
    zip_safe=False,
    install_requires=REQUIREMENTS,
    classifiers=[
        'Development Status :: 1 - Planning',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: Apache Software License',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Topic :: Internet',
    ]
)
