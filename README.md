# Packages_repos puppet module
[![Build Status](https://travis-ci.org/Adaptavist/puppet-packages_repos.svg?branch=master)](https://travis-ci.org/Adaptavist/puppet-packages_repos)

#### Table of Contents

1. [Overview - What is the packages_repos module?](#overview)
1. [Module Description - What does the module do?](#module-description)
1. [Module Dependencies - What does the module rely on?](#module-dependencies)
1. [Usage - The classes and defined types available for configuration](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: packages_repos](#class-packages_repos)
    * [Examples - Demonstrations of some configuration options](#examples)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
        * [Public Classes](#public-classes)
        * [Private Classes](#private-classes)
    * [Defined Types](#defined-types)
        * [Public Defined Types](#public-defined-types)
        * [Private Defined Types](#private-defined-types)
    * [Templates](#templates)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)
    * [Contributing to the module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Overview

The **packages_repo** module includes and sets up apt or yum repositories based on os, accepsts host specific repo settings.

## Module Description

Makes sure required repositories are registered and they are available before any package is installed.

Supports RedHat and Debian,
Default repos are set in params.pp. Custom repos definition is available on per host bases and merged with globaly defined by default.

For RedHat defaults are rpmforge, rpmforge-testing, rpmforge-extras

## Module Dependencies

This module depends on: 
* puppetlabs/apt
* example42/yum

## Usage

### Classes and defined types

#### Class: packages_repos

Main class that accepts OS specific repos hash as parameter and creates file resources.

* packages_repos::repos - hash of repos to include, on global level or per host, see examples for required fields
* packages_repos::merge_repos - identifies per host if default packages should be merged with custom ones

### Examples

Global level setup:

```
packages_repos::repos:
    'Debian':
        example_repo:
          location: 'http://example.adaptavist.com/'
          repos: '/'
          key: 'key'
          include_src: false
          release: ''
          key_content: "-----BEGIN PGP PUBLIC KEY BLOCK-----\n"
         another_example_repo:
           location: 'http://another_example.adaptavist.com/'
           repos: '/'
           key: 'key'
           include_src: false
           release: ''
           key_content: "-----BEGIN PGP PUBLIC KEY BLOCK-----\n"
    'RedHat':
        example_repo:
          baseurl => "http://example_yum.adaptavist.com",
          descr => "IUS Community repository",
          enabled => 1,
          gpgcheck => 0
```

Host specific setup

```
hosts:
  host1:
    packages_repos::merge_repos: 'false'
    packages_repos::repos:
      'RedHat':
        example_repo:
          baseurl => "http://example_yum.adaptavist.com",
          descr => "IUS Community repository",
          enabled => 1,
          gpgcheck => 0
```

## Reference

### Classes

#### Public classes

* packages_repos - registers OS specific repos and makes sure they are available before any package is installed.

#### Private classes

### Defined types

#### Public defined types

#### Private defined types

### Templates

## Limitations

* Module currently supports Debian and RedHat

## Development

### Contributing

* Create branch, name it according to functionality you are developing. Prefix with feature or bug, so the branch name looks like feature/<name_of_feature>

* Make changes and commit functionality to branch. Do not forget to write/adjust tests

* Create pull request, add reviewers

* Once approved, merge with master

### Running tests

Tests are located in spec folder. Subfolders classes and defines separates types of objects tested. Make sure .fixtures.yml contains all dependent modules to run tests. Functionality in all classes and defines has to be tested for all supported OS and cases of use. 

To run tests:
```
gem install bundler
bundle install
bundle exec rake spec
```


