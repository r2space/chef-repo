#
# Cookbook Name:: yukari-ap
# Recipe:: rabbitmq
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# install
yum_package "rabbitmq-server" do
  action :install
end

# enable management
execute "enable rabbitmq management" do
  command "/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management"
end

# start rabbitmq server
service "rabbitmq-server" do
  action [:start, :enable]
end

