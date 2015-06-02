#
class my_influxdb {
  package {'ruby':
    ensure => installed,
  }->
  exec {'influxdb_gem_install':
    command => 'gem install influxdb',
    user    => 'root',
    unless  => 'gem list | grep influxdb',
  }->
  class {'influxdb::server':
    input_plugins => {
      'input_plugins.graphite' => {
         'enabled'     => true,
         'address'     => '0.0.0.0',
         'port'        => 2003,
         'database'    => 'collectd',
         'udp_enabled' => true,
      }
    }
  }->
  exec {'create_collectddb':
    command => 'ruby -e "require \'influxdb\'; influxdb = InfluxDB::Client.new; influxdb.create_database(\'collectd\')"',
  }
}
