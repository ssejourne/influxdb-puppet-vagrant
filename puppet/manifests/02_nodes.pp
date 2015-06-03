#
node /^influxdb\d*.vagrant.dev$/ {
  ### We don't need the chef-client.
  service {'chef-client':
    ensure   => stopped,
  }

  # influxdb
  include my_influxdb

  firewall { '500 allow influxdb':
    port   => [ 2003, 8083, 8086, 8090, 8099 ],
    proto  => 'tcp',
    action => 'accept',
  }
  ### Collectd
  class { '::collectd':
    purge        => true,
    recurse      => true,
    purge_config => true,
  }

  collectd::plugin { 'cpu': }
  collectd::plugin { 'load': }
  collectd::plugin { 'memory': }
  collectd::plugin { 'swap': }
  collectd::plugin { 'disk': }
  collectd::plugin { 'interface': }

  class { 'collectd::plugin::write_graphite':
    graphitehost => $::fqdn,
  }

  # Grafana
  class { 'grafana': }

  firewall { '510 allow grafana':
    port   => 3000,
    proto  => 'tcp',
    action => 'accept'
  }
}

