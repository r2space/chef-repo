
server_ip="$1"
node_name="$2"
sshkey_file="$3"
sshkey_password="$4"
runlist="$5"

knife node delete $node_name
# Init client
./create_client.exp $server_ip $node_name $sshkey_file $sshkey_password

# Add node role
knife node run_list add $node_name "$runlist"

# Update client
./update_client.exp $server_ip $node_name $sshkey_file $sshkey_password

