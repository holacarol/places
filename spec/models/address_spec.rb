require 'spec_helper'

describe Address do

  before(:each) do
    @address_attr = {:formatted => "C/Test, 1\n 12345 Testcity (Testregion)\n Testland", :streetAddress => "C/Test, 1", 
                     :locality => "Testcity", :region => "Testregion", :postalCode => "12345", :country => "Testland"}
  end

  it "should create a new instance given valid attributes" do
    Address.create!(@address_attr)
  end

  describe "validations" do

    it "should require nonblank streetAddress" do
      @wrong_attr = {:formatted => "C/Test, 1\n 12345 Testcity (Testregion)\n Testland", :streetAddress => " ", 
                     :locality => "Testcity", :region => "Testregion", :postalCode => "12345", :country => "Testland"}
      Address.new(@wrong_attr).should_not be_valid
    end

    it "should require nonblank locality" do
      @wrong_attr = {:formatted => "C/Test, 1\n 12345 Testcity (Testregion)\n Testland", :streetAddress => "C/Test, 1", 
                     :locality => " ", :region => "Testregion", :postalCode => "12345", :country => "Testland"}
      Address.new(@wrong_attr).should_not be_valid
    end

    it "should requiere nonblank postalCode" do
      @wrong_attr = {:formatted => "C/Test, 1\n 12345 Testcity (Testregion)\n Testland", :streetAddress => "C/Test, 1", 
                     :locality => "Testcity", :region => "Testregion", :postalCode => " ", :country => "Testland"}
      Address.new(@wrong_attr).should_not be_valid
    end

    it "should require nonblank country" do
      @wrong_attr = {:formatted => "C/Test, 1\n 12345 Testcity (Testregion)\n Testland", :streetAddress => "C/Test, 1", 
                     :locality => "Testcity", :region => "Testregion", :postalCode => "12345", :country => " "}
      Address.new(@wrong_attr).should_not be_valid
    end

    it "should be only one address with the same attributes" do
      Address.create!(@address_attr)
      Address.create(@address_attr).should_not be_valid
    end
  end

end
