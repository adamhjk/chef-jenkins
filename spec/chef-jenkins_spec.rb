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
    @cj = Chef::Jenkins.new("/Users/adam/src/sandbox/opscode/environments/opscode")
  end

  describe "initialize" do
    it "should return a Chef::Jenkins object" do
      @cj.should be_a_kind_of(Chef::Jenkins)
    end
  end
end

describe "Chef::Jenkins::Config" do
  it "should have a default branch of master" do
    Chef::Jenkins::Config[:branch].should == "master"
  end

  it "should have a default git repository of nil" do
    Chef::Jenkins::Config[:repo].should == nil 
  end

  it "should have a default chef_server of nil" do
    Chef::Jenkins::Config[:chef_server].should == nil 
  end

  it "should have a default env_from of nil" do
    Chef::Jenkins::Config[:env_from].should == nil 
  end

  it "should have a default env_to of nil" do
    Chef::Jenkins::Config[:env_from].should == nil 
  end

  it "should have a default cwd argument of nil" do
    Chef::Jenkins::Config[:cwd].should == nil
  end
end
