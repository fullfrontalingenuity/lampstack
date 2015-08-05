# Class: mysql
#
# This module manages mysql
#
# Parameters:
#
# [*rootPassword*]
#   Root MySQL Password (default: password)
#
# Requires: see metadata.json
#
# Sample Usage:
#
# You can either include this class or define a class with custom root password:
#   class { 'lamp::mysql': rootPassword => 'your-password' }
#
class lamp::mysql($rootPassword = 'password') {
  # root password
  $rootPassword = 'password'

  # install mysql
  package { 'mysql-server':
    ensure  => latest,
    require => Exec['apt-get update']
  }

  # start service
  service { 'mysql':
    ensure  => running,
    require => Package['mysql-server'],
  }

  # set root password
  exec { 'set-mysql-password':
    unless  => 'mysqladmin -uroot -p$rootPassword status',
    command => 'mysqladmin -uroot password $rootPassword',
    require => Service['mysql'],
  }
}