#
# Cookbook Name:: yukari
# Recipe:: ap-restart
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

root_dir = "/opt/yukari"
path_smartcore = "#{root_dir}/SmartCore"
path_yukari = "#{root_dir}/YUKARiWeb"
cmd_stop = "forever stop #{path_yukari}/app.js"
cmd_start = "forever start -l #{path_yukari}/logs/forever.log -o #{path_yukari}/logs/out.log -e #{path_yukari}/logs/err.log -a --sourceDir #{path_yukari}/ app.js"
cmd_code = "#{cmd_stop}\n#{cmd_start}"

bash "ap_restart" do
  cwd "/opt/yukari/YUKARiWeb"
  code "#{cmd_code}"
end
