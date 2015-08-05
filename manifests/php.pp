# Class: php
#
# This module manages php
#
# Parameters:
# [*userPackages*]
#   A list of custom php5-* packages to install
#
# Requires: see metadata.json
#
# Sample Usage:
#
# You can either include this class or define a class with custom packages:
#   class { 'lamp::php': php5Packages => ['intl','mcrypt'] }
#
class lamp::php ($php5Packages = ['']) {
  # list of default packages
  $packages = [
    'php5',
    'php5-cli',
    'php5-mysql',
    'php-pear',
    'php5-dev',
    'php5-intl',
    'libapache2-mod-php5']

  package { $packages:
    ensure  => present,
    require => Exec['apt-get update']
  }

  #install user packages
  package { $php5Packages:
    ensure  => present,
    require => Exec['apt-get update']
  }

  # enable php in apache
  exec { 'a2enmod php5':
    command => '/usr/sbin/a2enmod php5',
    require => [Package['apache2'], Package['libapache2-mod-php5']],
    notify  => Service['apache2']
  }

  lamp::php5mods {$php5Packages:}
}