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
    @cj = Chef::Jenkins.new
  end

  describe "initialize" do
    it "returns a Chef::Jenkins object" do
      @cj.should be_a_kind_of(Chef::Jenkins)
    end

    it "sets the user.name git config variable" do
      @cj.git.config["user.name"].should == Chef::Config[:jenkins][:git_user]
    end

    it "sets the user.email git config variable" do
      @cj.git.config["user.email"].should == Chef::Config[:jenkins][:git_email]
    end
  end

  describe "bump_patch_level" do
    it "updates metadata.rb to have an incremented patch version" do
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

  describe "write_current_commit" do
    it "writes the current commit out to a file" do
      @cj.write_current_commit(AH::INFLIGHT)
      cfile = File.join(AH::INFLIGHT, ".chef_jenkins_last_commit") 
      File.exists?(cfile).should == true
      # The length of a shasum
      IO.read(cfile).length.should == 40
    end
  end

  describe "commit_changes" do
    it "commits changes to git, with the number and list of cookbooks" do
      cookbook_list = [ "apache2", "ntp" ]
      @cj.git.stub!(:commit).and_return(true)
      @cj.git.should_receive(:commit).with("2 cookbooks patch levels updated by Chef Jenkins\n#{cookbook_list.join}", :add_all => true)
      @cj.commit_changes(cookbook_list)
    end
  end

  describe "read_last_commit" do
    it "returns the last commit" do
      @cj.write_current_commit(AH::INFLIGHT)
      @cj.read_last_commit(AH::INFLIGHT).length.should == 40
    end
  end

  describe "integration_branch_name" do
    it "uses the BUILD_TAG environment variable if it is set" do
      ENV['BUILD_TAG'] = "snoopy"
      @cj.integration_branch_name.should == "snoopy"
    end

    it "sets a manual build tag with the number of seconds since the epoch if no environment value is set" do
      ENV.delete('BUILD_TAG')
      @cj.integration_branch_name.should =~ /^chef-jenkins-manual-\d+$/
    end
  end

  describe "find_changed_cookbooks" do
    it "prints a list of cookbooks changed since two commits" do
      cblist = @cj.find_changed_cookbooks('5979a584b0c4e10df0a868609c0b4f0f74058860', '013162d426ed0b627470dbb3209ae7af5d7ef216', ["#{AH::ASSET_DIR}/cookbooks"]) 
      cblist.include?("apache2").should == true
      cblist.include?("ntp").should == true
    end
  end
end

