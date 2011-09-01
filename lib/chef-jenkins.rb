require 'rubygems'
require 'mixlib/config'

class Chef
  class Jenkins
    class Config
      extend Mixlib::Config
   
      # The branch to use
      branch "master"

      # The git repository URL to fetch
      repo nil

      # The chef server to update
      chef_server nil

      # The environment to sync from
      env_from nil

      # The environment to sync to
      env_to nil

      # The directory holding your git repository - defaults to Dir.pwd 
      cwd Dir.pwd
    end

    def update
      git = Git.open(Chef::Jenkins::Config[:pwd])
      last_commit = git.log(1)

    end

  end
end
