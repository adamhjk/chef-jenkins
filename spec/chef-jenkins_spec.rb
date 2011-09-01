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

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Chef::Jenkins" do
  before(:each) do
    AH.reset!
    Chef::Config.from_file(AH.file("config.rb"))
    @cj = Chef::Jenkins.new("/Users/adam/src/sandbox/opscode/environments/opscode")
  end

  describe "initialize" do
    it "should return a Chef::Jenkins object" do
      @cj.should be_a_kind_of(Chef::Jenkins)
    end
  end

  describe "bump_patch_level" do
    it "should update metadata.rb to have an incremented patch version" do
      @cj.bump_patch_level(AH.file("metadata.rb"))
      has_correct_version = false
      IO.foreach(AH.file("metadata.rb")) do |line|
        if line =~ /^version '0\.99\.5'$/
          has_correct_version = true
          break
        end
      end
      has_correct_version.should == true
    end
  end
end

