### If you want to override any of these values, put them in a file called knife_override.rb
current_dir = File.dirname(__FILE__)
chef_org = File.basename( File.expand_path("../", current_dir  ) )
knife_override = "#{current_dir}/knife_override.rb"

puts "\nOrganization: #{chef_org}\n"
puts "===============================\n"

log_level                :info
log_location             STDOUT
node_name                "#{ENV['CHEF_NODE_NAME']}"
client_key               "#{ENV['HOME']}/.chef/#{node_name}.pem"
validation_client_name   "#{chef_org}-validator"
validation_key           "#{current_dir}/#{chef_org}-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/#{chef_org}"
cache_type               'BasicFile'
cache_options( :path =>  "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

# Allow overriding values in this knife.rb
Chef::Config.from_file(knife_override) if File.exist?(knife_override)