require 'spec_helper'

describe "Places" do

  before(:each) do
    user = Factory(:user)
    visit root_path
    fill_in :user_email,    :with => user.email
    fill_in :user_password,    :with => user.password
    click_button 'Sign in'
  end

  describe "creation" do
    address_attr = Factory.attributes_for(:address)
    place_attr = Factory.attributes_for(:place)

    describe "failure" do

      it "should not make a new place without a title" do
        lambda do
          visit new_place_path
          fill_in :place_title, :with => ""
          fill_in :place_position, :with => place_attr[:position]
          fill_in :place_url, :with => place_attr[:url]
	  fill_in :place_address_attributes_streetAddress, :with => address_attr[:streetAddress]
	  fill_in :place_address_attributes_locality	, :with => address_attr[:locality]
	  fill_in :place_address_attributes_region	, :with => address_attr[:region]
	  fill_in :place_address_attributes_postalCode	, :with => address_attr[:postalCode]
	  fill_in :place_address_attributes_country	, :with => address_attr[:country]
          click_button
          response.should have_selector("div#error_explanation")
        end.should_not change(Place, :count)
      end

      it "should not make a new place without a position" do
        lambda do
          visit new_place_path
          fill_in :place_title, :with => place_attr[:title]
          fill_in :place_position, :with => ""
          fill_in :place_url, :with => place_attr[:url]
	  fill_in :place_address_attributes_streetAddress, :with => address_attr[:streetAddress]
	  fill_in :place_address_attributes_locality	, :with => address_attr[:locality]
	  fill_in :place_address_attributes_region	, :with => address_attr[:region]
	  fill_in :place_address_attributes_postalCode	, :with => address_attr[:postalCode]
	  fill_in :place_address_attributes_country	, :with => address_attr[:country]
          click_button
          response.should have_selector("div#error_explanation")
        end.should_not change(Place, :count)
      end

      it "should not make a new place without an address.streetAddres" do
        lambda do
          visit new_place_path
          fill_in :place_title, :with => place_attr[:title]
          fill_in :place_position, :with => place_attr[:position]
          fill_in :place_url, :with => place_attr[:url]
	  fill_in :place_address_attributes_streetAddress, :with => ""
	  fill_in :place_address_attributes_locality	, :with => address_attr[:locality]
	  fill_in :place_address_attributes_region	, :with => address_attr[:region]
	  fill_in :place_address_attributes_postalCode	, :with => address_attr[:postalCode]
	  fill_in :place_address_attributes_country	, :with => address_attr[:country]
          click_button
          response.should have_selector("div#error_explanation")
        end.should_not change(Place, :count)
      end
    end



    describe "success" do

      it "should make a new place" do
        lambda do
          visit new_place_path
          fill_in :place_title, :with => place_attr[:title]
          fill_in :place_position, :with => place_attr[:position]
          fill_in :place_url, :with => place_attr[:url]
	  fill_in :place_address_attributes_streetAddress, :with => address_attr[:streetAddress]
	  fill_in :place_address_attributes_locality	, :with => address_attr[:locality]
	  fill_in :place_address_attributes_region	, :with => address_attr[:region]
	  fill_in :place_address_attributes_postalCode	, :with => address_attr[:postalCode]
	  fill_in :place_address_attributes_country	, :with => address_attr[:country]
          click_button
          response.should have_selector("div.place_name", :content => place_attr[:title])
        end.should change(Place, :count).by(1)
      end
    end
  end
end
