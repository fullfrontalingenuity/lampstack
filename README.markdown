# lampstack #

### Default setup
Create a manifest that has the following code:

```puppet
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

include lamp::apache
include lamp::php
# default root password is 'password'
include lamp::mysql
include lamp::phpmyadmin

exec {"apt-get update":
  command => "apt-get update"
}
```

### Setup with custom PHP5 packages or root MySQL password

```puppet
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

include lamp::apache
include lamp::phpmyadmin

# Note: only installs packages that begin with php5-
class { 'lamp::php':
    php5Packages => ['list','of','packages']
}

class { 'lamp::mysql':
    rootPassword => 'YOUR-PASSWORD-HERE'
}

exec {"apt-get update":
  command => "apt-get update"
}
```
