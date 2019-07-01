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
    'rule_files' => ['/prometheus/disk.rules'],
    'scrape_configs' => [
      prom_job('prometheus', 9090),
      prom_job('node-exporter', 9100),
      prom_job('grafana', 3000)
    ]
  }
end

def prom_config_to_yaml
  prom_config_builder.to_yaml
end

def prom_config_to_file(work_dir: Dir.pwd, file_name: 'prometheus', file_ext: 'yml')
  File.open("#{work_dir}/#{file_name}.#{file_ext}", 'w') { |file| file.write(prom_config_to_yaml) }
end

def free_disk_space_alert
  {
    group_name: 'disk', 
    alert_name: 'FreeDiskSpaceLessThan50Persent',
    expr: '100.0 - 100 * (node_filesystem_avail_bytes / node_filesystem_size_bytes) >= 50', 
    interval: '15m',
    severity: 'warning',
    summary: 'Free Disk Space on {{ $labels.mountpoint }} is below threshold of 50%'    
  }
end

def alert_template(alert)
  {
    'groups' => [
      {
        'name' => alert[:group_name],
        'rules' => [
          {
            'alert' => alert[:alert_name],
            'expr' => alert[:expr],
            'for' => alert[:interval],
            'labels' => {
              'severity' => alert[:severity]
            },
            'annotations' => {
              'summary' => alert[:summary]
            }
          }
        ]
      }
    ]
  }
end

def alert_template_to_yaml
  disk_alert = free_disk_space_alert
  alert_template(disk_alert).to_yaml
end

def alert_template_to_file(work_dir: Dir.pwd, file_name: 'disk', file_ext: 'rules')
  File.open("#{work_dir}/#{file_name}.#{file_ext}", 'w') { |file| file.write(alert_template_to_yaml) }
end
