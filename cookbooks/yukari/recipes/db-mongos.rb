#
# Cookbook Name:: yukari-ap
# Recipe:: db-mongos
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Server Init
#include_recipe "yukari-ap::init"

type="mongos"
bin="mongos"
port=node['ports']["#{type}"]

mongo_root="/opt/#{type}"
pidfilepath="/var/mongodb/#{type}.pid"
log_dir="/var/log/mongodb"
log_file="#{log_dir}/#{type}.log"
conf_dir="/etc/mongodb"
conf_file="#{conf_dir}/#{type}.conf"


dbs = [ ]
shards = []

port_mongoconfig = node['ports']["mongoconfig"];
port_mongod = node['ports']["mongod"];
node['host']['dbs'].each do |db|
  dbs.push("#{db['name']}:#{port_mongoconfig}")
  shards.push("db.runCommand({addShard:'#{db['name']}:#{port_mongod}'})");
end
#shards.push("db.runCommand({'enableSharding': 'yukari'})")

configdb=dbs.join(',')
cmd_add_shards=shards.join(';')

# Download mongodb
include_recipe "yukari-ap::db-install"
# install  mongodb
execute "${type} install" do
  cwd "/tmp"
  command "rm -rf /opt/#{type}; cp -R -n /tmp/mongodb #{mongo_root}" 
end

# Create config directory
directory conf_dir do
  recursive true
  action :create
end

# Create log directory
directory log_dir do
  recursive true
  action :create
end
# Create config file
template "config" do
  path conf_file
  source "#{type}.conf.erb"
  variables({
    :port => port,
    :pidfilepath => pidfilepath,
    :logpath => log_file,
    :configdb => configdb
  })
end

# Create daemon script
template "daemon_script" do
  path "/etc/init.d/#{type}"
  source "mongo.daemon.erb"
  mode 0755
  owner "root"
  group "root"  
  variables({
    :type => type,
    :dir_root => mongo_root,
    :conf_file => conf_file,
    :bin => bin
  })
end

execute "set start" do
  command "chkconfig #{type} on"
end
# Start DB
execute "start db" do
  command "service #{type} restart"
end

# Add shard server
execute "add shard" do
  command <<-EOF
  #{mongo_root}/bin/mongo --eval "#{cmd_add_shards}" admin
  EOF
end
