# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'lib/vagrant'
require_relative 'lib/prometheus'
require_relative 'lib/alerts'
require_relative 'lib/grafana'
require_relative 'lib/dashboard'

base_dir = File.dirname(File.expand_path(__FILE__))
opts = vagrant_config(base_dir)

case ARGV[0]
when 'provision', 'up'
  # config generators
  dirs = []
  dirs << "#{base_dir}/prometheus"
  dirs << "#{base_dir}/grafana/provisioning/datasources"
  dirs << "#{base_dir}/grafana/provisioning/dashboards"
  dirs << "#{base_dir}/grafana/dashboards"
  dirs.each do |d|
    puts "Creating Dir: #{d}"
    FileUtils.mkdir_p(d) unless File.exists?(d)
  end
  alert_template_to_file(work_dir: dirs[0])
  prom_config_to_file(work_dir: dirs[0])
  ds_provision_config_to_file(work_dir: dirs[1])
  dash_provision_config_to_file(work_dir: dirs[2])
  dash_to_json_file(work_dir: dirs[3], file_name: 'disk_alerts')
when 'halt', 'destroy'
  puts 'Skipping Generators Phaze'
  puts 'Cleaning up Configurations'
  %w(prometheus grafana).each do |d|
    FileUtils.rm_rf(d) if File.exists?(d)
  end
end

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
