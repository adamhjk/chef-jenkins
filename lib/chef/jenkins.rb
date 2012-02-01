#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'rubygems'
require 'chef/jenkins/config'
require 'chef/config'
require 'chef/log'
require 'chef/knife'
require 'chef/knife/cookbook_upload'
require 'chef/environment'
require 'chef/exceptions'
require 'chef/cookbook_loader'
require 'chef/cookbook_uploader'
require 'git'

class Chef
  class Jenkins
    VERSION = "0.1.0"

    attr_accessor :git

    def initialize
      @git = Git.open(Chef::Config[:jenkins][:repo_dir])
      @git.config("user.name", Chef::Config[:jenkins][:git_user])
      @git.config("user.email", Chef::Config[:jenkins][:git_email])
    end

    def bump_patch_level(metadatarb)
      File.open(metadatarb, 'r+') do |f|
        lines = f.readlines
        lines.each do |line|
          if line =~ /^version\s+["'](\d+)\.(\d+)\.(\d+)["'].*$/
            major = $1
            minor = $2
            patch = $3
            new_patch = patch.to_i + 1
            Chef::Log.info("Incrementing #{metadatarb} version from #{major}.#{minor}.#{patch} to #{major}.#{minor}.#{new_patch}") 
            line.replace("version '#{major}.#{minor}.#{new_patch}'\n")
          end
        end
        f.pos = 0
        lines.each do |line|
          f.print line
        end
        f.truncate(f.pos)
      end
    end

    def find_all_cookbooks(cookbook_path=Chef::Config[:cookbook_path])
      changed_cookbooks = []
      cookbook_path.each do |path|
        Dir[File.join(File.expand_path(path), '*')].each do |cookbook_dir|
          if File.directory?(cookbook_dir)
            if cookbook_dir =~ /#{File.expand_path(path)}\/(.+)/
              changed_cookbooks << $1
            end
          end
        end
      end
      changed_cookbooks.uniq
    end

    def find_changed_cookbooks(sha1, sha2, cookbook_path=Chef::Config[:cookbook_path], repo_path=Chef::Config[:jenkins][:repo_dir])
      changed_cookbooks = []
      @git.diff(sha1, sha2).each do |diff_file|
        cookbook_path.each do |path|
          full_path_to_file = File.expand_path(File.join(repo_path, diff_file.path))
          if full_path_to_file =~ /^#{File.expand_path(path)}\/(.+?)\/.+/
            changed_cookbooks << $1
          end
        end
      end
      changed_cookbooks.uniq
    end

    def current_commit
      @git.log(1)
    end

    def write_current_commit(path=Chef::Config[:jenkins][:repo_dir])
      File.open(File.join(path, ".chef_jenkins_last_commit"), "w") do |f|
        f.print(current_commit)
      end
      @git.add(File.join(path, ".chef_jenkins_last_commit"))
      @git.commit("Updating the last auto-commit marker for Chef Jenkins")
      true
    end

    def read_last_commit(path=Chef::Config[:jenkins][:repo_dir])
      if File.exists?(File.join(path, ".chef_jenkins_last_commit"))
        IO.read(File.join(path, ".chef_jenkins_last_commit"))
      else
        nil
      end
    end

    def commit_changes(cookbook_list=[])
      @git.commit("#{cookbook_list.length} cookbooks patch levels updated by Chef Jenkins\n\n" + cookbook_list.join("\n"), :add_all => true)
    end

    def integration_branch_name
      if ENV.has_key?('BUILD_TAG')
        ENV['BUILD_TAG']
      else
        "chef-jenkins-manual-#{Time.new.to_i}"
      end
    end

    def git_branch(branch_name)
      @git.branch(branch_name).checkout
    end

    def add_upstream(upstream_url=Chef::Config[:jenkins][:repo_url])
      begin
        @git.add_remote("upstream", upstream_url)
      rescue Git::GitExecuteError => e
        Chef::Log.debug("We already added the upstream - skipping")
      end
    end

    def push_to_upstream(branch=Chef::Config[:jenkins][:branch])
      @git.push("upstream", "HEAD:#{branch}")
    end

    def upload_cookbooks(cookbooks=[])
      cu = Chef::Knife::CookbookUpload.new
      cu.name_args = cookbooks 
      cu.config[:environment] = Chef::Config[:jenkins][:env_to]
      cu.config[:freeze] = true
      cu.run
    end

    def prop(env_from=Chef::Config[:jenkins][:env_from], env_to=Chef::Config[:jenkins][:env_to])
      from = Chef::Environment.load(env_from)  
      to = Chef::Environment.load(env_to)
      to.cookbook_versions(from.cookbook_versions)
      to.save
    end
    
    def sync(cookbook_path=Chef::Config[:cookbook_path], repo_dir=Chef::Config[:jenkins][:repo_dir])
      add_upstream

      git_branch(integration_branch_name)

      cookbooks_to_change = []

      last_commit = read_last_commit
      if last_commit
        cookbooks_to_change = find_changed_cookbooks(last_commit, 'HEAD')
      else
        cookbooks_to_change = find_all_cookbooks
      end

      if cookbooks_to_change.length == 0 || cookbooks_to_change.nil?
        Chef::Log.info("No cookbooks have changed")
        exit 0
      end

      cookbooks_to_change.each do |cookbook|
        cookbook_path.each do |path|
          metadata_file = File.join(path, cookbook, "metadata.rb")
          bump_patch_level(metadata_file) if File.exists?(metadata_file)
        end
      end

      commit_changes(cookbooks_to_change)

      write_current_commit(repo_dir)

      push_to_upstream

      upload_cookbooks(cookbooks_to_change)
    ensure
      @git.branch("master").checkout
    end

  end
end
