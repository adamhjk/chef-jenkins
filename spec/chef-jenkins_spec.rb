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
