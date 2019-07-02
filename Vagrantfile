# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'lib/vagrant'
require_relative 'lib/prometheus'
require_relative 'lib/alerts'
require_relative 'lib/grafana'

work_dir = File.dirname(File.expand_path(__FILE__))
opts = vagrant_config(work_dir)
dirs = []
dirs << "#{work_dir}/prometheus"
dirs << "#{work_dir}/grafana/provisioning/datasources"
dirs << "#{work_dir}/grafana/provisioning/dashboards"
dirs << "#{work_dir}/grafana/templates"
dirs.each do |d|
  FileUtils.mkdir_p(d) unless File.exists?(d)
end
alert_template_to_file(work_dir: dirs[0])
prom_config_to_file(work_dir: dirs[0])
ds_provision_config_to_file(work_dir: dirs[1])
dash_provision_config_to_file(work_dir: dirs[2])

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
