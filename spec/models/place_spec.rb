require 'spec_helper'

describe Place do

  before(:each) do
    @address_attr = {
	:streetAddress => "1, Test St.",
	:locality => "Testcity",
	:region => "Testregion",
	:postalCode => "12345",
	:country => "Testland" }
    @tie = Factory(:friend)
    @attr = {
	:title => "Test place",
	:position => "+48.8577+002.295",
	:address_attributes => @address_attr,
	:url => "http://www.testplace.com",
	:author_id => @tie.receiver.id ,
	:owner_id => @tie.sender.id,
	:user_author_id => @tie.receiver.id }
  end

  it "should create a new instance given valid attributes" do
    place = Place.new(@attr)
    place.save!
  end

  describe "address associations" do
 
    before(:each) do
      @place = Place.create(@attr)
    end

    it "should have an address attribute" do
      @place.should respond_to(:address)
    end
  end

  describe "validations" do
    
    it "should require a nonblank title" do
      @wrong_place = {:title => " ", :position => "+48.8577+002.295",
	:address_attributes => @address_attr, :url => "http://www.testplace.com", :author_id => @tie.receiver.id,
	:owner_id => @tie.sender.id, :user_author_id => @tie.receiver.id }
      Place.new(@wrong_place).should_not be_valid
    end

    it "should require nonblank position" do
      @wrong_place = {:title => "Test place", :position => " ",
	:address_attributes => @address_attr, :url => "http://www.testplace.com", :author_id => @tie.receiver.id,
	:owner_id => @tie.sender.id, :user_author_id => @tie.receiver.id }
      Place.new(@wrong_place).should_not be_valid
    end

    it "should require nonblank author_id" do
      @wrong_place = {:title => "Test place", :position => "+48.8577+002.295",
	:address_attributes => @address_attr, :url => "http://www.testplace.com", :author_id => " ",
	:owner_id => @tie.sender.id, :user_author_id => @tie.receiver.id }
      Place.new(@wrong_place).should_not be_valid
    end

    it "should require nonblank owner_id" do
      @wrong_place = {:title => "Test place", :position => "+48.8577+002.295",
	:address_attributes => @address_attr, :url => "http://www.testplace.com", :author_id => @tie.receiver.id,
	:owner_id => " ", :user_author_id => @tie.receiver.id }
      Place.new(@wrong_place).should_not be_valid
    end

    it "should require nonblank user_author_id" do
      @wrong_place = {:title => "Test place", :position => "+48.8577+002.295",
	:address_attributes => @address_attr, :url => "http://www.testplace.com", :author_id => @tie.receiver.id,
	:owner_id => @tie.sender.id, :user_author_id => " " }
      Place.new(@wrong_place).should_not be_valid
    end

    it "should reject long title" do
       @wrong_place = {:title => "a"*51, :position => "+48.8577+002.295",
	:address_attributes => @address_attr, :url => "http://www.testplace.com", :author_id => @tie.receiver.id,
	:owner_id => @tie.sender.id, :user_author_id => " " }
      Place.new(@wrong_place).should_not be_valid
    end
  end

end
