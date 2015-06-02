#
#import "nodes"

Exec {
  path => '/usr/local/bin:/usr/bin:/usr/sbin:/bin'
}

filebucket { 'main': }

# set defaults for file ownership/permissions
File {
  backup => main,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}

# Timezone stuff
class { 'timezone':
  timezone => 'Europe/Paris',
} -> class { '::ntp':
  restrict => ['127.0.0.1'],
}

