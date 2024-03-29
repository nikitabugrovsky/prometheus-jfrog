# -*- mode: ruby -*-
# vi: set ft=ruby :

# here you will find helper methods 
# related to grafana dashboards

require 'json'
require 'pp'

@alerts_dash = {"annotations"=>{"list"=>[{"builtIn"=>1, "datasource"=>"-- Grafana --", "enable"=>true, "hide"=>true, "iconColor"=>"rgba(0, 211, 255, 1)", "name"=>"Annotations & Alerts", "type"=>"dashboard"}]}, "editable"=>true, "gnetId"=>nil, "graphTooltip"=>0, "id"=>2, "links"=>[], "panels"=>[{"columns"=>[], "datasource"=>"Prometheus Alertmanager", "description"=>"Sample Alerts Dash", "fontSize"=>"100%", "gridPos"=>{"h"=>7, "w"=>24, "x"=>0, "y"=>0}, "id"=>2, "links"=>[], "options"=>{}, "pageSize"=>nil, "scroll"=>true, "showHeader"=>true, "sort"=>{"col"=>0, "desc"=>true}, "styles"=>[{"alias"=>"Time", "dateFormat"=>"YYYY-MM-DD HH:mm:ss", "pattern"=>"Time", "type"=>"date"}, {"alias"=>"", "colorMode"=>"row", "colors"=>["rgba(50, 172, 45, 0.97)", "rgba(237, 129, 40, 0.89)", "rgba(245, 54, 54, 0.9)"], "decimals"=>2, "mappingType"=>1, "pattern"=>"/.*/", "thresholds"=>["2", "3"], "type"=>"string", "unit"=>"short", "valueMaps"=>[{"text"=>"Warning", "value"=>"2"}, {"text"=>"High", "value"=>"3"}, {"text"=>"Critical", "value"=>"4"}]}], "targets"=>[{"annotations"=>false, "expr"=>"alertname=\"FreeDiskSpaceLessThan50Persent\"", "labelSelector"=>"org,alertname,device,summary,severity", "legendFormat"=>"{{ msg }}", "refId"=>"A", "target"=>"Query", "type"=>"table"}], "timeFrom"=>nil, "timeShift"=>nil, "title"=>"Prometheus Alerts", "transform"=>"table", "type"=>"table"}], "schemaVersion"=>18, "style"=>"dark", "tags"=>["prometheus", "alerts", "alertmanager"], "templating"=>{"list"=>[]}, "time"=>{"from"=>"now-6h", "to"=>"now"}, "timepicker"=>{"refresh_intervals"=>["5s", "10s", "30s", "1m", "5m", "15m", "30m", "1h", "2h", "1d"], "time_options"=>["5m", "15m", "1h", "6h", "12h", "24h", "2d", "7d", "30d"]}, "timezone"=>"browser", "title"=>"Prometheus Alerts", "uid"=>"cvc", "version"=>2}

def dash_to_json
  @alerts_dash.to_json
end

def dash_to_json_file(work_dir: Dir.pwd, file_name: nil, file_ext: 'json')
  puts "Generating Dashboard File: #{work_dir}/#{file_name}.#{file_ext}"
  File.open("#{work_dir}/#{file_name}.#{file_ext}", 'w') { |file| file.write(dash_to_json) }
end