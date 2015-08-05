define lamp::php5mods {
    # enable php5 mods
    exec { "php5enmod ${title}":
      command => "php5enmod ${title}",
      notify  => Service['apache2'],
      require => Package["php5-${title}"]
    }
  }