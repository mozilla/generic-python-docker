#!/usr/bin/env python

# -*- coding: utf-8 -*-

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import os
import sys

from setuptools import setup, find_packages

readme = open('README.md').read()

setup(
    name='generic-docker-python',
    python_requires='>=3.6.0',
    version='0.0.0',
    description='A sample application',
    long_description=readme,
    author='Frank Bertsch',
    author_email='frank@mozilla.com',
    url='https://github.com/fbertsch/generic-docker-python',
    packages=find_packages(include=['python_application']),
    package_dir={'python-application': 'python_application'},
    entry_points={
        'console_scripts': [
            'python-application=python_application.__main__:main',
        ],
    },
    include_package_data=True,
    install_requires=[
        'click',
    ],
    license='Mozilla',
)
