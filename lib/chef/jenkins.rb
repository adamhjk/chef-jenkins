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

class Chef
  class Jenkins
    # if we have never run, upload everything, then store the ENV[GIT_COMMIT]
    # from jenkins
    #
    # if we can reload the last SHA of HEAD, do git diff --name-only
    # ENV[GIT_COMMIT] LAST_SHA. If the changed files are cookbooks, roles,
    # environments, nodes, whatever, run the syntax check and then upload
    # them.
    def update
    end

  end
end
