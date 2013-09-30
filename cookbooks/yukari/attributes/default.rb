
# All host define
default['host']['all'] = [ ]

# chef
default['host']['chef'] = {"name" => "chef", "domain" => "chef.dreamarts.co.jp", "ip" => "175.184.44.109"}
default['host']['all'].push(default['host']['chef'])

# Load Balancer
default['host']['lb'] = {"name" => "lb", "domain" => "lb.dreamarts.co.jp", "ip" => "222.158.197.122"}
default['host']['all'].push(default['host']['lb'])

# zabbix
default['host']['zabbix'] = {"name" => "zabbix", "domain" => "zabbix.dreamarts.co.jp", "ip" => "222.158.197.155"}
default['host']['all'].push(default['host']['zabbix'])

# ap(ap, mongos)
default['host']['aps'] = [
  {"name" => "ap1", "domain" => "ap1.dreamarts.co.jp", "ip" => "175.184.47.77"},
  {"name" => "ap2", "domain" => "ap2.dreamarts.co.jp", "ip" => "175.184.20.40"}
]
default['host']['all'].concat(default['host']['aps'])
# ap host
default['host']['all'].push({"name" => "mongo", "domain" => "mongo.dreamarts.co.jp", "ip" => "127.0.0.1"})

# rabbitMQ
default['host']['mqs'] = [
  {"name" => "mq", "domain" => "mq.dreamarts.co.jp", "ip" => "222.158.199.212"},
  {"name" => "mq2", "domain" => "mq2.dreamarts.co.jp", "ip" => "175.184.20.42"}
]
default['host']['all'].concat(default['host']['mqs'])

# dbs(mongod, mongoconfig)
default['host']['dbs'] = [ 
  {"name" => "db1", "domain" => "db1.dreamarts.co.jp", "ip" => "175.184.46.54"},
  {"name" => "db2", "domain" => "db2.dreamarts.co.jp", "ip" => "175.184.20.41"},
  {"name" => "db3", "domain" => "db3.dreamarts.co.jp", "ip" => "175.184.45.100"}
]
default['host']['all'].concat(default['host']['dbs'])

# backup
default['host']['backups'] = [
  {"name" => "backup", "domain" => "backup.dreamarts.co.jp", "ip" => "175.184.47.166"},
]
default['host']['all'].concat(default['host']['backups'])


##################################################
default['path']['db']['etc'] = "/etc/mongodb"

#######
# port
default['ports'] = {
  "mongos"      => "27017",
  "mongoconfig" => "27018",
  "mongod"      => "27019"
}

# AP 
default["ap"]["SmartCore"]["path"] = "/opt/yukari/SmartCore"
default["ap"]["SmartCore"]["git_repo"] = "https://github.com/r2space/SmartCore.git"
default["ap"]["SmartCore"]["git_reference"] = "master" # Version
default["ap"]["YUKARiWeb"]["path"] = "/opt/yukari/YUKARiWeb"
default["ap"]["YUKARiWeb"]["git_repo"] = "https://github.com/r2space/YUKARiWeb.git"
default["ap"]["YUKARiWeb"]["git_reference"] = "master" # Version

# Java
default["ap"]["SmartTools"]["java"] = "/usr/lib/jvm/java-1.7.0-openjdk.x86_64/"
default["ap"]["SmartTools"]["jar"] = "/opt/yukari/SmartTools/target/SmartTools-1.0-SNAPSHOT-jar-with-dependencies.jar"
