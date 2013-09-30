#
# Cookbook Name:: yukari-ap
# Recipe:: ap
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Server Init
#include_recipe "yukari-ap::init"

# Install SmartCore
directory "/opt/yukari/SmartCore" do
  recursive true
  action :create
end
git "/opt/yukari/SmartCore" do
  repository "https://github.com/r2space/SmartCore.git"
  reference "master"
  action :sync
end
bash "npm install " do
  cwd "/opt/yukari/SmartCore"
  code <<-EOH
  npm install
  EOH
end
# Install YUKARiWeb
directory "/opt/yukari/YUKARiWeb" do
  recursive true
  action :create
end
git "/opt/yukari/YUKARiWeb" do
  repository "https://github.com/r2space/YUKARiWeb.git"
  reference "master"
  action :sync
end
bash "npm install " do
  cwd "/opt/yukari/YUKARiWeb"
  code <<-EOH
  npm install
  EOH
end

# Install forever
#bash "install forever" do
#  cwd "/tmp"
#  code <<-EOH
#  npm install forever -g
#  EOH
#end

include_recipe "yukari-ap::ap-restart"
