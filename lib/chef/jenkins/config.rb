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
require 'chef/config'

class Chef
  class Config
    jenkins({
      # The branch to use
      :branch => "master",

      # The environment to sync from
      :env_from => nil,

      # The environment to sync to
      :env_to => nil,

      # The directory holding your git repository - defaults to Dir.pwd 
      :repo_dir => Dir.pwd,

      # The repo to push changes to
      :repo_url => nil,

      # The git username
      :git_user => "Jenkins CI",

      # The git email
      :git_email => "jenkins@example.com",
    })
  end
end
