#
# Cookbook Name:: yukari
# Recipe:: init
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum::epel"

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



