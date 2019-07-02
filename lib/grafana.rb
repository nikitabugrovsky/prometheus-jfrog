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

def ds_provider_to_yml(api_version: 1, ds_list: [])
  ds_list << datasource_tmpl(alertmanager_opts)
  {
    'apiVersion' => api_version,
    'datasources' => ds_list
  }.to_yaml
end

def ds_provision_config_to_file(work_dir: Dir.pwd, file_name: 'datasources', file_ext: 'yml')
  puts "Generating Datasource Provisioning Configuration File: #{work_dir}/#{file_name}.#{file_ext}"
  File.open("#{work_dir}/#{file_name}.#{file_ext}", 'w') { |file| file.write(ds_provider_to_yml) }
end

def dash_provider_opts
{
  name: 'Jfrog Dashboards',
  type: 'file',
  orgId: 1,
  folder: '',
  disableDeletion: true,
  updateIntervalSeconds: 10,
  path: '/var/lib/grafana/dashboards'
}
end

def provider_tmpl(opts)
  {
    'name' => opts[:name],
    'type' => opts[:type],
    'orgId' => opts[:orgId],
    'folder' => opts[:folder],
    'disableDeletion' => opts[:disableDeletion],
    'updateIntervalSeconds' => opts[:updateIntervalSeconds],
    'options' => {
      'path' => opts[:path]
    }
  }
end

def dash_provider_to_yml(api_version: 1, providers: [])
  providers << provider_tmpl(dash_provider_opts)
  {
    'apiVersion' => api_version,
    'providers' => providers
  }.to_yaml
end

def dash_provision_config_to_file(work_dir: Dir.pwd, file_name: 'dashboards', file_ext: 'yml')
  puts "Generating Dashboard Provisioning Configuration File: #{work_dir}/#{file_name}.#{file_ext}"
  File.open("#{work_dir}/#{file_name}.#{file_ext}", 'w') { |file| file.write(dash_provider_to_yml) }
end
