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
