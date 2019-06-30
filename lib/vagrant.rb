# -*- mode: ruby -*-
# vi: set ft=ruby :

# here you will find helper methods to start
# vagrant env

require 'yaml'

def vagrant_config(work_dir)
  @options = {}
  conf_files = Dir.glob("#{work_dir}/conf/*.yml")
  conf_files.each do |f|
    @options.merge!(YAML.load_file(f))
  end
  @options
end

def prom_global_config(interval: '15s', timeout: '10s', eval_int: '15s')
  {
    'scrape_interval' => interval,
    'scrape_timeout' => timeout,
    'evaluation_interval' => eval_int,
    'external_labels' => {
      'org' => 'jfrog'
    }
  }
end

def prom_alerting_config(host: 'alertmanager', port: 9093, timeout: '15s')
  { 
    'alertmanagers' => [
      { 
        'static_configs' => [
          {
            'targets' => ["#{host}:#{port}"]
          }
        ],
        'timeout' => timeout
      }
    ]
  }
end

def prom_job(job_name, port)
  {
    'job_name' => job_name,
    'metrics_path' => '/metrics',
    'static_configs' => [
      'targets' => ["#{job_name}:#{port}"]
    ]
  }
end

def prom_config_builder
  {
    'global' => prom_global_config,
    'alerting' => prom_alerting_config,
    'scrape_configs' => [
      prom_job('prometheus', 9090),
      prom_job('node-exporter', 9100)
    ]
  }
end

def prom_config_to_yaml
  prom_config_builder.to_yaml
end

def prom_config_to_file(work_dir: Dir.pwd, file_name: 'prometheus', file_ext: 'yml')
  File.open("#{work_dir}/#{file_name}.#{file_ext}", 'w') { |file| file.write(prom_config_to_yaml) }
end
