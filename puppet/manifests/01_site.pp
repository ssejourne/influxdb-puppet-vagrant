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
  restrict  => [
    'default ignore',
    '-6 default ignore',
    '127.0.0.1',
    '-6 ::1',
  ],
}

# Sysctl stuff

# Turn on execshield
sysctl {'kernel.exec-shield': value => '1' }
sysctl {'kernel.randomize_va_space': value => '1' }
# Enable IP spoofing protection
sysctl {'knet.ipv4.conf.all.rp_filter': value => '1' }
# Disable IP source routing
sysctl {'net.ipv4.conf.all.accept_source_route': value => '0' }
# Ignoring broadcasts request
sysctl {'net.ipv4.icmp_echo_ignore_broadcasts': value => '1' }
sysctl {'net.ipv4.icmp_ignore_bogus_error_messages': value => '1' }
# Make sure spoofed packets get logged
#sysctl {'net.ipv4.conf.all.log_martians': value => '1' }
# Not needed anymore
sysctl { 'vm.swappiness': ensure => absent }

# Fail2ban
class { 'fail2ban':
  package_ensure       => 'latest',
  config_file_string   => '# THIS FILE IS MANAGED BY PUPPET',
  config_file_template => "fail2ban/${::lsbdistcodename}/etc/fail2ban/jail.conf.erb",
}

# Firewall stuff
class { ['fw::pre', 'fw::post']: }

class { 'firewall': }

firewall { '100 allow ssh':
  port   => '22',
  proto  => 'tcp',
  action => 'accept',
}

firewall { '200 allow bacula':
  port   => '9102',
  proto  => 'tcp',
  action => 'accept',
}

