#
# Cookbook Name:: yukari
# Recipe:: ap
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Server Init
#include_recipe "yukari::init"

#### nginx ####
template "nginx.repo" do
  path "/etc/yum.repos.d/nginx.repo"
  source "nginx.repo.erb"
end
yum_package "nginx" do
  action :install
end
template "nginx.config" do
  path "/etc/nginx/conf.d/default.conf"
  source "ap.nginx.erb"
end
service "nginx" do
  action [:restart, :enable]
end

#### varnish ####
remote_file "/root/varnish-release-3.0-1.el6.noarch.rpm" do
  source "http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release-3.0-1.el6.noarch.rpm"
end

rpm_package "/root/varnish-release-3.0-1.el6.noarch.rpm" do
  options "--nosignature" 
  action :install
end

yum_package "varnish" do
  action :install
end
template "varnish.vcl" do
  path "/etc/varnish/default.vcl"
  source "varnish.vcl.erb"
  variables({
    :host => Chef::Config[:node_name]
  })
end
service "varnish" do
  action [:start, :enable]
end

#### nodejs ####
remote_file "/tmp/node-v0.10.18.tgz" do
  source "http://nodejs.org/dist/v0.10.18/node-v0.10.18-linux-x64.tar.gz"
  action :create_if_missing
end
execute "node unzip" do
  cwd "/tmp"
  command <<-EOF
  tar -zxvf node-v0.10.18.tgz;
  EOF
  not_if { ::File.exists?("/tmp/node-v0.10.18-linux-x64")}
end
execute "install node" do
  cwd "/tmp"
  command <<-EOF
  rm -rf /opt/node
  rm -f /usr/bin/node
  rm -f /usr/bin/npm
  cp -R -n  node-v0.10.18-linux-x64 /opt/node
  ln -s /opt/node/bin/node /usr/bin/node
  ln -s /opt/node/lib/node_modules/npm/bin/npm-cli.js /usr/bin/npm
  EOF
end

#### git ####
yum_package "git" do
  action :install
end

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
bash "install forever" do
  cwd "/tmp"
  code <<-EOH
  npm install forever -g
  EOH
end

include_recipe "yukari::ap-restart"
