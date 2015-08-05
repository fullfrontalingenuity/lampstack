# Class: lampstack
#
# This module manages LAMP components
#
# Parameters: none
#
# Actions:
#
# Requires: see metadata.json
#
# Sample Usage:
#

class lampstack (
  $files = undef,
  $file_lines = undef,
  $filesystem_mounts = {},
){

include lamp::apache
include lamp::phpmyadmin

# Note: only installs packages that begin with php5-
class { 'lamp::php':
      php5Packages => ['list','of','packages']
}

class { 'lamp::mysql':
      rootPassword => 'YOUR-PASSWORD-HERE'
}


  notice("I was passed: ${filesystem_mounts}")

  validate_hash($filesystem_mounts)

  include ::sanity::cpu

  class { '::sanity::file_contents':
    files          => $files,
    file_lines => $file_lines,
  }

  file { [ '/etc/facter', '/etc/facter/facts.d', ]:
    ensure => 'directory',
  }

  file { '/etc/facter/facts.d/filesystem_sizes.bash':
    ensure     => file,
    source => 'puppet:///modules/sanity/filesystem_sizes.bash',
  }

  create_resources ('::sanity::filesystem', $filesystem_mounts)

  include ::sanity::fqdn
  include ::sanity::nfs
  include ::sanity::ram
  include ::sanity::ssh
  include ::sanity::symlinks

  case $::osfamily {
    'windows','Solaris','Darwin': {
      fail("Unsupported osfamily: ${::osfamily}")
    }
    default: { }
  }

}
