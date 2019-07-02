# -*- mode: ruby -*-
# vi: set ft=ruby :

# here you will find helper methods 
# related to prometheus alerts

require 'yaml'

def free_disk_space_alert
  {
    group_name: 'disk', 
    alert_name: 'FreeDiskSpaceLessThan50Persent',
    expr: '100.0 - 100 * (node_filesystem_avail_bytes / node_filesystem_size_bytes) <= 50', 
    interval: '1m',
    severity: '2',
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
  puts "Generating Alerts File: #{work_dir}/#{file_name}.#{file_ext}"
  File.open("#{work_dir}/#{file_name}.#{file_ext}", 'w') { |file| file.write(alert_template_to_yaml) }
end
