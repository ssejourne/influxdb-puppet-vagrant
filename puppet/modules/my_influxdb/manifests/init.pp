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
    },
    seed_servers  => ['influxdb1:8090','influxdb2:8090','influxdb3:8090'],
  }

  # Create collectd db and user with collectd as password
  exec {'create_collectd_db':
    command => 'ruby -e "require \'influxdb\'; influxdb = InfluxDB::Client.new; influxdb.create_database(\'collectd\'); influxdb.create_database_user(\'collectd\', \'collectd\', \'collectd\')"',
    unless  => 'ruby -e "require \'influxdb\'; influxdb = InfluxDB::Client.new; puts influxdb.get_database_list" | grep collectd',
    require => Class['influxdb::server'],
  }

  
}
