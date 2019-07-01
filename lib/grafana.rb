# -*- mode: ruby -*-
# vi: set ft=ruby :

# here you will find helper methods
# related to grafana configuration

require 'yaml'

def alertmanager_opts
  {
    name: 'Prometheus Alertmanager',
    type: 'camptocamp-prometheus-alertmanager-datasource',
    access: 'proxy',
    orgId: 1,
    url: 'http://alertmanager:9093',
    isDefault: true,
    version: 1,
    editable: false,
    jsonData: {
      'severity_critical' => '4',
      'severity_high' => '3',
      'severity_warning' => '2',
      'severity_info' => '1',
      'keepCookies' => []
    }
  }
end

def datasource_tmpl(opts)
  {
    'name' => opts[:name],
    'type' => opts[:type],
    'access' => opts[:access],
    'orgId' => opts[:orgId],
    'url' => opts[:url],
    'isDefault' => opts[:isDefault],
    'version' => opts[:version],
    'editable' => opts[:editable],
  }.merge({'jsonData' => opts[:jsonData]}) if opts[:jsonData]
end

def datasource_to_yml(api_version: 1, ds_list: [])
  ds_list << datasource_tmpl(alertmanager_opts)
  {
    'apiVersion' => api_version,
    'datasources' => ds_list
  }.to_yaml
end

def datasource_config_to_file(work_dir: Dir.pwd, file_name: 'datasource', file_ext: 'yml')
  File.open("#{work_dir}/#{file_name}.#{file_ext}", 'w') { |file| file.write(datasource_to_yml) }
end
