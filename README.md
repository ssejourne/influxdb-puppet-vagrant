# Influxdb and grafana provisionning by Puppet

##Description

vagrant environment to deploy and test graphite, influxdb and grafana

##Setup
```
  $ (cd puppet-contrib && librarian-puppet update)
  $ vagrant up
```
##Tests

* http://influxdb1.vagrant.dev:3000 : Grafana (login : admin / admin)
* http://influxdb1.vagrant.dev:8083 : Influxdb admin (login : root / root)

It works with influxdb2 or influxdb3 as well

##TODO

* collectd : multiple node config for write_graphite

