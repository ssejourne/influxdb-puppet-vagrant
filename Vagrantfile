# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"
#  config.vm.box = "ubuntu/trusty64"

  # Configure plugins
  unless ENV["VAGRANT_NO_PLUGINS"]

    required_plugins = %w( vagrant-cachier landrush)
    required_plugins.each do |plugin|
      system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
    end

    # Use landrush to manage DNS entries
    # Check status with : vagrant landrush status
    if Vagrant.has_plugin?("landrush")
      config.landrush.enabled = true
    end
    # $ vagrant plugin install vagrant-cachier
    # Need nfs-kernel-server system package on debian/ubuntu host
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.scope = :box
      config.cache.synced_folder_opts = {
        type: :nfs,
        # The nolock option can be useful for an NFSv3 client that wants to avoid the
        # NLM sideband protocol. Without this option, apt-get might hang if it tries
        # to lock files needed for /var/cache/* operations. All of this can be avoided
        # by using NFSv4 everywhere. Please note that the tcp option is not the default.
        mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
      }
    end
  end

#  config.vm.synced_folder "puppet/files", "/etc/puppet/files"

#  if Vagrant.has_plugin?("vagrant-librarian-puppet")
#    config.librarian_puppet.puppetfile_dir = "puppet-contrib"
#    config.librarian_puppet.resolve_options = { :force => true }
#  end

  influxdb_servers = {
    :'influxdb1' => '192.168.65.11',
#    :'influxdb2' => '192.168.65.12',
#    :'influxdb3' => '192.168.65.13'
  }

  influxdb_servers.each do |server_name, server_ip|
    config.vm.define server_name do |server|
      server.vm.hostname = server_name.to_s + ".vagrant.dev"
      server.vm.network :private_network, ip: server_ip
      server.vm.provider :virtualbox do |vb|
        vb.memory = '1024'
      end
    end
  end

# Puppet provisionning
  config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "."
      puppet.module_path = [ "puppet/modules", "puppet-contrib/modules"]
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.options="--fileserverconfig=/vagrant/puppet/fileserver.conf --summarize --verbose"
      #puppet.options="--verbose --debug --trace --summarize"
  end
end

