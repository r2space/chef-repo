#
# Cookbook Name:: yukari
# Recipe:: init
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum::epel"

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

#yum_package "nodejs" do
#  version "0.10.18-1.el6"
#  action :install
#end
#
#yum_package "npm" do
#  action :install
#end

#### git ####
yum_package "git" do
  action :install
end

#### hostname, hosts ####
template "hosts" do
  path "/etc/hosts"
  source "hosts.erb"
  variables(
    :hosts => node['host']['all']
  ) 
end

_hostname = Chef::Config[:node_name] #config[:chef_node_name]
ruby_block 'edit /etc/sysconfig/network' do
  block do
    rc = Chef::Util::FileEdit.new('/etc/sysconfig/network')
    rc.search_file_replace_line(/^HOSTNAME/, "HOSTNAME=#{_hostname}")
    rc.write_file
  end
end


# service "varnish"
#  action [:start, :enable]
# end



