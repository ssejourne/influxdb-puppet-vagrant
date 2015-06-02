#
node /^influxdb\d*.vagrant.dev$/ {
  ### We don't need the chef-client.
  service {'chef-client':
    ensure   => stopped,
  }

  # influxdb
  include my_influxdb

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
}

