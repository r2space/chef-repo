#
# Cookbook Name:: yukari
# Recipe:: rabbitmq_consumer
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#
yum_package "java-1.7.0-openjdk-devel" do
  action :install
end

yum_package "jakarta-commons-daemon-jsvc" do
  action :install
end

remote_file "/tmp/apache-maven-3.1.0-bin.tar.gz" do
  source "http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/maven/maven-3/3.1.0/binaries/apache-maven-3.1.0-bin.tar.gz"
end

execute "install maven" do
  cwd "/tmp"
  command "tar -zxvf apache-maven-3.1.0-bin.tar.gz; mv apache-maven-3.1.0 /opt/apache-maven-3.1.0"
  not_if { ::File.exists?("/opt/apache-maven-3.1.0")}
end

directory "/opt/yukari/SmartTools" do
  recursive true
  action :create
end

#### git ####
yum_package "git" do
  action :install
end

git "/opt/yukari/SmartTools" do
  repository "https://github.com/r2space/SmartTools.git"
  reference "master"
  action :sync
end

execute "mvn package" do
  cwd "/opt/yukari/SmartTools"
  environment ({'MAVEN_OPTS' => '-Xmx512m -Xms128m -Xss2m'})
  command "/opt/apache-maven-3.1.0/bin/mvn package"
end

template "apn" do
  path "/etc/rc.d/init.d/yi-apn"
  source "yi-apn.erb"
  mode 0755
  variables({
    :java => node[:ap][:SmartTools][:java], 
    :jar => node[:ap][:SmartTools][:jar]
  })
end

template "imgcut" do
  path "/etc/rc.d/init.d/yi-imgcut"
  source "yi-imgcut.erb"
  mode 0755
  variables({
    :java => node[:ap][:SmartTools][:java], 
    :jar => node[:ap][:SmartTools][:jar]
  })
end

template "imgunion" do
  path "/etc/rc.d/init.d/yi-imgunion"
  source "yi-imgunion.erb"
  mode 0755
  variables({
    :java => node[:ap][:SmartTools][:java], 
    :jar => node[:ap][:SmartTools][:jar]
  })
end


service "yi-imgcut" do
  action [:start, :enable]
end


