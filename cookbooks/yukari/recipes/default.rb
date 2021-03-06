#
# Cookbook Name:: yukari
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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

#### nginx ####
template "nginx.repo" do
  path "/etc/yum.repos.d/nginx.repo"
  source "nginx.repo.erb"
end

yum_package "nginx" do
  action :install
end

#### nodejs ####
yum_package "nodejs" do
  version "0.10.18-1.el6"
  action :install
end

yum_package "npm" do
  action :install
end

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

_hostname = node['host']['ap1']['name']
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



