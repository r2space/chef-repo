#!/usr/bin/expect -f
set timeout 3600 

set server_ip [lindex $argv 0]
set node_name [lindex $argv 1]
set sshkey_file [lindex $argv 2]
set sshkey_password [lindex $argv 3]

if {"$server_ip" == "" || "$node_name" == "" || "$sshkey_file" == "" || "$sshkey_password" == ""} {
  send_user "# Parameter is error!  server_ip: $server_ip; node_name: $node_name ; sshkey_file: $sshkey_file; sshkey_password: $sshkey_password\r"
  exit;
} 

spawn ssh $server_ip -i $sshkey_file

expect "Enter passphrase for key" { send "$sshkey_password\r\n" }
#       "Are you sure you want to continue connecting (yes/no)" {
#            send "yes\r\n"
#            expect "Enter passphrase for key"
#            send "$sshkey_password\r\n"
#        }

# update
expect "root*\]#"
send "chef-client \r"

# Over
expect "root*\]#"
send " \r"
