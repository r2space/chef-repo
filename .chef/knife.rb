log_level                :info
log_location             STDOUT
node_name                'root'
client_key               '/opt/chef-repo/.chef/root.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef-server/chef-validator.pem'
chef_server_url          'https://chef.dreamarts.co.jp:443'
syntax_check_cache_path  '/opt/chef-repo/.chef/syntax_check_cache'
