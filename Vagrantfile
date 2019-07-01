# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'lib/vagrant'
require_relative 'lib/prometheus'
require_relative 'lib/alerts'

work_dir = File.dirname(File.expand_path(__FILE__))
opts = vagrant_config(work_dir)
alert_template_to_file(work_dir: work_dir)
prom_config_to_file(work_dir: work_dir)

Vagrant.configure('2') do |config|
  config.vm.define opts['provider']['virtualbox']['vm']['hostname'] do |cfg|
    cfg.vm.box      = opts['provider']['virtualbox']['vm']['box']
    cfg.vm.hostname = opts['provider']['virtualbox']['vm']['hostname']
    cfg.vm.network  opts['provider']['virtualbox']['vm']['net'].to_sym

    cfg.vm.provision opts['provisioner']['docker']['name'].to_sym
    cfg.vm.provision opts['provisioner']['compose']['name'].to_sym, yml: opts['provisioner']['compose']['yml'], run: opts['provisioner']['compose']['run']
  end

  opts['forwarded_ports'].each do |port|
    config.vm.network 'forwarded_port', guest: port, host: port
  end
  
  config.vm.provider :virtualbox do |vb|
    vb.memory   = opts['provider']['virtualbox']['vm']['mem']
    vb.cpus     = opts['provider']['virtualbox']['vm']['cpu']
  end
end
