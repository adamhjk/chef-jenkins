current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "adam"
client_key               "#{current_dir}/adam.pem"
chef_server_url          "https://api.opscode.com/organizations/opscode"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/cookbooks"]
jenkins({
  :repo_path => File.expand_path("#{current_dir}/../../")
})
