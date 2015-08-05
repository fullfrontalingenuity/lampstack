# Class: apache
#
# This module manages apache
#
# Parameters: none
#
# Actions:
#
# Requires: see metadata.json
#
# Sample Usage:
#
class lamp::apache {
  # install apache package
  package { 'apache2':
    ensure  => present,
    require => Exec['apt-get update']
  }

  # enable mod_rewrite
  exec { 'a2enmod rewrite':
    command => '/usr/sbin/a2enmod rewrite',
    require => Package['apache2']
  }

  # clear directory
  file { '/etc/apache2/sites-enabled':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    before  => File['/etc/apache2/sites-enabled/web_config'],
    require => Package['apache2']
  }

  # copy apache config
  file { '/etc/apache2/sites-enabled/web_config':
    ensure  => present,
    source  => 'puppet:///modules/lamp/web_config',
    notify  => Service['apache2'],
    require => Package['apache2']
  }

  service { 'apache2':
    ensure    => running,
    require   => Package['apache2'],
    subscribe => [Exec['a2enmod rewrite'],
                  File['/etc/apache2/sites-enabled/web_config']],
  }

}