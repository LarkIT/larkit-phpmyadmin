#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with phpmyadmin](#setup)
    * [What phpmyadmin affects](#what-phpmyadmin-affects)
    * [Beginning with phpmyadmin](#beginning-with-phpmyadmin)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A puppet module to install [phpMyAdmin](https://www.phpmyadmin.net/).

## Module Description

phpMyAdmin is a web application used to administrator MySQL and MariaDB.  This puppet module will install and configure phpMyAdmin.  An example is provided below on how to use this with the [puppetlabs/apache](https://forge.puppetlabs.com/puppetlabs/apache) module to also set up Apache.

## Setup

### What phpmyadmin affects

* phpMyAdmin package
* phpMyAdmin configuration

### Beginning with phpmyadmin

phpMyAdmin can be installed simply by including the module:

```puppet
    class { 'phpmyadmin': }
```

## Usage

By itself, installing phpMyAdmin will not be very useful as it needs a webserver to run.  To install phpmyadmin with puppetlab's apache module:

```puppet
    class { 'apache': }
    class { 'apache::mod::php': }
    apache::vhost { 'phpmyadmin':
      docroot     => '/var/www/html',
      port        => $port,
      aliases     => [
        {
          alias => '/phpmyadmin',
          path  => '/usr/share/phpMyAdmin'
        }, {
          alias => '/phpMyAdmin',
          path  => '/usr/share/phpMyAdmin'
        }
      ],
      directories => [
        {
          'path' => '/usr/share/phpMyAdmin/',
          'allow' => 'from all',
        }, {
          'path' => '/usr/share/phpMyAdmin/setup/',
          'deny' => 'from all',
          'allow' => 'from none',
        }, {
          'path' => '/usr/share/phpMyAdmin/libraries/',
          'deny' => 'from all',
          'allow' => 'from none',
        }
      ],
    }
```

## Reference

### Public classes

#### Class: `phpmyadmin`

##### `config`

Configuration parameters to apply to phpmyadmin.  This should be a hash with the key as the property and the appropriate value.

##### `servers`

Servers to be added phpMyAdmin.  This is an array of hashes with the hash containing the properties and values for the host.

##### `config_file`

Location of the phpMyAdmin configuration file.

##### `package_name`

Name of the phpMyAdmin package

##### `www_user`
User name the config file should be owend by.  This will typically be your web server

##### `www_group`

Group the config file should be owend by.  This will typically be your web server

##### `version`

Version of phpMyAdmin to install

## Limitations

This has only been tested on CentOS 6 and 7.

## Development

Improvements and bug fixes are greatly appreciated.  See the [contributing guide](https://github.com/LarkIT/larkit-phpmyadmin/CONTRIBUTING.md) for
information on adding and validating tests for PRs.

## Changelog / Contributors

[Changelog](https://github.com/LarkIT/larkit-phpmyadmin/blob/master/CHANGELOG)

[Contributors](https://github.com/LarkIT/larkit-phpmyadmin/graphs/contributors)
