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
require 'tempfile'

class Chef
  class Jenkins
    VERSION = "0.1.0"

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

    def check_for_cookbook_changes
    end
    
    # if we have never run, upload everything, then store the ENV[GIT_COMMIT]
    # from jenkins
    #
    # if we can reload the last SHA of HEAD, do git diff --name-only
    # ENV[GIT_COMMIT] LAST_SHA. If the changed files are cookbooks, roles,
    # environments, nodes, whatever, run the syntax check and then upload
    # them.
    def sync(git_repo_path, chef_environment)
      # if never run
      #   bump all patch levels
      #   write out HEAD shasum
      #   commit
      #   push
      #     on push fail, rebase
      #     on rebase failure, die
      #   exit 0
      


      #  if run before
      #   for each modified cookbook
      #     bump patch levels
      #   commit
      #   push
      #     on push fail, rebase
      #     on rebase failure, die
    end

  end
end
