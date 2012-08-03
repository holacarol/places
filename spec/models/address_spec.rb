require 'spec_helper'

describe Address do

  before(:each) do
    @user = Factory(:user)
    @address_attr = {	
	:streetAddress => "1, Test St.", 
        :locality => "Testcity",
	:region => "Testregion",
	:postalCode => "12345",
	:country => "Testland"}
    @place_attr = {
	:title => "Test place",
	:latitude => "40.4166909",
  :longitude => "-3.7003454",
  :address_attributes => @address_attr,
  :phone_number => "915 34 27 84",
	:url => "http://www.testplace.com",
	:author_id => @user.actor.id ,
	:owner_id => @user.actor.id,
	:user_author_id => @user.actor.id }
  end

  it "should create a new instance given valid attributes" do
    Address.create!(@address_attr)
  end

  describe "place associations" do

    before(:each) do
      @address = Address.create(@address_attr)
    end

    it "should have a places attribute" do
      @address.should respond_to(:places)
    end
  end

  describe "validations" do

    it "should require nonblank streetAddress" do
      @wrong_attr = {:streetAddress => " ", :locality => "Testcity", :region => "Testregion", :postalCode => "12345", :country => "Testland"}
      Address.new(@wrong_attr).should_not be_valid
    end

    it "should require nonblank locality" do
      @wrong_attr = {:streetAddress => "1, Test St.", :locality => " ", :region => "Testregion", :postalCode => "12345", :country => "Testland"}
      Address.new(@wrong_attr).should_not be_valid
    end

    it "should require nonblank region" do
      @wrong_attr = {:streetAddress => "1, Test St.", :locality => " ", :region => " ", :postalCode => "12345", :country => "Testland"}
      Address.new(@wrong_attr).should_not be_valid
    end

    it "should requiere nonblank postalCode" do
      @wrong_attr = {:streetAddress => "1, Test St.", :locality => "Testcity", :region => "Testregion", :postalCode => " ", :country => "Testland"}
      Address.new(@wrong_attr).should_not be_valid
    end

    it "should require nonblank country" do
      @wrong_attr = {:streetAddress => "1, Test St.", :locality => "Testcity", :region => "Testregion", :postalCode => "12345", :country => " "}
      Address.new(@wrong_attr).should_not be_valid
    end

    it "should be only one address with the same attributes" do
      Address.create!(@address_attr)
      Address.create(@address_attr).should_not be_valid
    end
  end

end
