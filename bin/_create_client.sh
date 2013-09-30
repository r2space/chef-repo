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

expect "root*\]#"
send "cd /tmp/ \r"

expect "root*\]#"
send "test ! -d /opt/chef && curl -L http://opscode.com/chef/install.sh | bash \r"


expect "root*\]#"
send "rm -rf /etc/chef && mkdir /etc/chef && cd /etc/chef && knife configure client -s https://chef.dreamarts.co.jp ./ \r"

expect "root*\]#"
send "echo \"node_name \'$node_name\'\" >> /etc/chef/client.rb \r"

expect "root*\]#"
send "echo '-----BEGIN RSA PRIVATE KEY-----\nMIIEogIBAAKCAQEA11BTAONKM7RYvclY9qWyp7mMVMR1zJ4OeF3NQY7m+X6nhe34\nwv2jTkup3ITtQdKDMGKVb9ybXzpDqy9eozitvx56RIbLSl246SxiqyZlJpgwkat3\nBRiNDJZgg5qQ+PuzK9jmY0ryG2UMDMtFFAmMrRjQ9e0JBqBdd8HdgdZctFivFUPk\nW+iRsH2O7VXKIJzzWqH82ChY15FyCR1P3udPusHGlg4nHiiBcq4TK4EzNZG3lnOj\nCAKLZaFSkgV6ivKxy9uR0njnUviXVgQNx+4T8E6Vs+eSt/cqpEmX2FT82c4E6vWu\nau3RE/C17O/K0JmLvTIpun3r5pmRLQAzYDAQbQIDAQABAoIBAHVy7mQMl7xOgx27\niFi6mBKfxymyJOPhz9jeqgk5z0qHSRBoeAq9WmhqI5UTuWvvTfqFvChRuTsfyCvH\n4iK81yHqmR1qPdgp+aTPvl7HyeNcnxnG41yXQNF98dW36Z63hcvEPCArkJda7lDI\nTL0aXG9LmyibDRJdRb7+tDqP2O/Sc7vG4cpdXba86CwZ/reH9dZoCNnDfKsgGljQ\nlt036v1DUetGKnp6q8tb4K/fJD7GxmFPx15ChkhxMPQOwCtokYBpKs27nUj9oOIx\n1mwB3kMpoHl7hAL+ATfqaqed9gYcdVhMQKXbddmg+r9gaeDU9Ek/n+3CkDOjeOEp\n4YRDs20CgYEA+muy0q4CsvP1+uCxJncPWVC28kakYveteon4B5AdbknngBpj2msO\ns5vo04HSFRwh6GeKGJyn28E2sD5LWBAxGJBBUdacHRrkdOD3Lt8zxyadkyXZcWhn\nwhN/cW/blEW6Je1bpMDbESxxeJrSshHnJCAimWnx2fQbAcFhnQgneOcCgYEA3Bxj\nuKbHWzdO72VCgXbvHjxu2kpGaIENI65NMXcmV6zqzxGH5lXIwre3JfTco7QWH5KM\nweVJOT3qzK7NpZqq7zyvrJprUOKekp1cnJWsAwHoCbq/T+sZDJ5P8zEt8N3njFF0\nBSqbIGYOKChHGCYW1I9kGTlKrtRxG6wFOo9O3YsCgYBhl/lwG/rXTTaPGGRRzlLA\nBzHVR+ym2UnVmNF9+Q9PPSQoi6Bgrhpjqx5Y155NNdKNJVTvdJYCkdFDbHOmlWDc\n5tNeFppuyV1Bo68RqFEgiw8cGsMcbIkLXNftGJ/lsCr0vwVZNwPpNH3gd84nMcz4\nCkIRsfVccMLZs0jcjyH6/wKBgG6ohynqDwe4wqJwUgMsfALDdyefd85KMwThOEXK\nFSi28kWwFpaiQhBCtH0MoXBbtVOiJcnFMA7rJgRJTXIYVB96bwdjithbVkV3f3vp\nc1T/vFxH2q6fDzTc0mz9KI+TwDk3KhD+3oZnSG6/8R4e6BNtE3Hq77T9cO/sh6Rt\nL8UJAoGAPrDYL+xNj9oxgdr8ie8B8UkzZT1PWA9ary5Bz0jeBbHF4xRpauiVlwgs\nmUoXNyPEWm0r2aJRCXjdC2hMpKzcI+BkO0iphcA/OCKg19bXETZIS+esEGRe8xpo\nB0lu7DNoLTKjl5HT/xKmNhJPHX47Rc06uAFEpSpGBN6wWrTqynU=\n-----END RSA PRIVATE KEY-----' > /etc/chef/validation.pem \n "

expect "root*\]#"
send "echo '175.184.44.109 chef.dreamarts.co.jp' >> /etc/hosts \r"

expect "root*\]#"
send "chef-client -c /etc/chef/client.rb \r"

expect "root*\]#"
send " \r"
