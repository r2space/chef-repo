
remote_file "/tmp/mongodb.tgz" do
  source "http://downloads.mongodb.org/linux/mongodb-linux-x86_64-2.4.6.tgz"
  action :create_if_missing
end

execute "mongodb unzip" do
  cwd "/tmp"
  command "tar -zxvf mongodb.tgz; cp -R -n  mongodb-linux-* mongodb"
  not_if { ::File.exists?("/tmp/mongodb")}
end

