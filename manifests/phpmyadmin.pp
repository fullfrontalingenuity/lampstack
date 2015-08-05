# Class: phpmyadmin
#
# This module manages phpmyadmin
#
# Parameters: none
#
# Actions:
#
# Requires: see metadata.json
#
# Sample Usage:
#
class lamp::phpmyadmin {
  # install phpmyadmin
  package { 'phpmyadmin':
    ensure  => present,
    require => [Package['apache2'], Package['php5-mysql'],
                Package['mysql-server']]
  }

  # setup access for phpmyadmin
  exec { 'conf symlinks':
    command => 'ln -s /etc/phpmyadmin/apache.conf
                /etc/apache2/conf-available/phpmyadmin.conf',
    creates => '/etc/apache2/conf-available/phpmyadmin.conf',
    require => Package['phpmyadmin']
  }

  exec { 'a2enconf phpmyadmin':
    notify  => Service['apache2'],
    command => 'a2enconf phpmyadmin',
    require => Exec['conf symlinks']
  }
}