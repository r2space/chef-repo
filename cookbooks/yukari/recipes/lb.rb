#
# Cookbook Name:: yukari
# Recipe:: rabbitmq
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#### nginx ####
template "nginx.repo" do
  path "/etc/yum.repos.d/nginx.repo"
  source "nginx.repo.erb"
end

# install
yum_package "nginx" do
  action :install
end

template "nginx default" do
  path "/etc/nginx/conf.d/default.conf"
  source "lb.erb"
  variables({
    :hosts => node['host']['aps']
  })
end

# start nginx
service "nginx" do
  action [:start, :enable]
end

