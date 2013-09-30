#
# Cookbook Name:: yukari
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "database::mysql"

# install
yum_package "mysql-server" do
  action :install
end
yum_package "zabbix20-server" do
  action :install
end
yum_package "zabbix20-server-mysql" do
  action :install
end
yum_package "zabbix20-web-mysql" do
  action :install
end

# start server
service "mysqld" do
  action [:start, :enable]
end

# create user
mysql_database "zabbix" do
  connection ({:host => "127.0.0.1", :username => "root", :password => ""})
  encoding "utf8"
  action :create
  notifies :create, "mysql_database_user[zabbix]", :immediately
  notifies :grant, "mysql_database_user[zabbix]", :immediately
  notifies :run, "execute[zabbix_populate_schema]", :immediately
  notifies :run, "execute[zabbix_populate_image]", :immediately
  notifies :run, "execute[zabbix_populate_data]", :immediately
  notifies :restart, "service[zabbix-server]", :immediately
end

# create user, grant atuh
mysql_database_user "zabbix" do
  connection ({:host => "127.0.0.1", :username => "root", :password => ""})
  password "zabbix"
  database_name "zabbix"
  privileges [:select,:update,:insert,:create,:drop,:delete,:index,:alter]
  action :nothing
end

# execute sql
execute "zabbix_populate_schema" do
  command "/usr/bin/mysql -uzabbix -pzabbix -Dzabbix < /usr/share/zabbix-mysql/schema.sql"
  action :nothing
end
execute "zabbix_populate_image" do
  command "/usr/bin/mysql -uzabbix -pzabbix -Dzabbix < /usr/share/zabbix-mysql/images.sql"
  action :nothing
end
execute "zabbix_populate_data" do
  command "/usr/bin/mysql -uzabbix -pzabbix -Dzabbix < /usr/share/zabbix-mysql/data.sql"
  action :nothing
end

# set zabbix password
ruby_block 'edit /etc/zabbix_server.conf' do
  block do
    rc = Chef::Util::FileEdit.new('/etc/zabbix_server.conf')
    rc.search_file_replace_line(/DBPassword=/, "DBPassword=zabbix")
  end
end

# set php parameters
ruby_block 'edit /etc/httpd/conf.d/zabbix.conf' do
  block do
    rc = Chef::Util::FileEdit.new('/etc/httpd/conf.d/zabbix.conf')
    rc.search_file_delete_line(/php_admin_value memory_limit/)
    rc.search_file_delete_line(/php_admin_value post_max_size/)
    rc.search_file_delete_line(/php_admin_value upload_max_filesize/)
    rc.search_file_delete_line(/php_admin_value max_execution_time/)
    rc.search_file_delete_line(/php_admin_value max_input_time/)
    rc.search_file_delete_line(/php_admin_value date.timezone/)
    rc.insert_line_after_match(/^<Directory \"\/usr\/share\/zabbix\">/, "    php_admin_value memory_limit 256M")
    rc.insert_line_after_match(/^<Directory \"\/usr\/share\/zabbix\">/, "    php_admin_value post_max_size 32M")
    rc.insert_line_after_match(/^<Directory \"\/usr\/share\/zabbix\">/, "    php_admin_value upload_max_filesize 16M")
    rc.insert_line_after_match(/^<Directory \"\/usr\/share\/zabbix\">/, "    php_admin_value max_execution_time 600")
    rc.insert_line_after_match(/^<Directory \"\/usr\/share\/zabbix\">/, "    php_admin_value max_input_time 600")
    rc.insert_line_after_match(/^<Directory \"\/usr\/share\/zabbix\">/, "    php_admin_value date.timezone \"Asia/Tokyo\"")
    rc.write_file
  end
end

service "zabbix-server" do
  action [:start, :enable]
end
service "httpd" do
  action [:start, :enable]
end
