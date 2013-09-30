#
# Cookbook Name:: yukari
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# install
yum_package "zabbix20-agent" do
  action :install
end

# set server ip
ruby_block 'edit /etc/zabbix/zabbix_agentd.conf' do
  block do
    rc = Chef::Util::FileEdit.new('/etc/zabbix/zabbix_agentd.conf')
    rc.search_file_replace_line(/^Server=/, "Server=#{node[:host][:zabbix][:ip]}")
    rc.search_file_replace_line(/^ServerActive=/, "ServerActive=#{node[:host][:zabbix][:ip]}")
    rc.write_file
  end
end

# start zabbix agent server
service "zabbix-agent" do
  action [:start, :enable]
end

