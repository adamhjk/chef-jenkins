$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'chef-jenkins'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}


module AH
  ASSET_DIR = File.join(File.dirname(__FILE__), "assets")
  INFLIGHT = File.join(File.dirname(__FILE__), "in-flight")

  def self.reset!
    system("rm -rf #{INFLIGHT}")
    system("mkdir -p #{INFLIGHT}")
    system("cp -r #{File.expand_path(File.join(ASSET_DIR, "*"))} #{INFLIGHT}")
    true
  end

  def self.file(filename)
    File.expand_path(File.join(INFLIGHT, filename))
  end

  def self.repo_path
    File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end

end

RSpec.configure do |config|
end
