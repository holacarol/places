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

    describe "failure" do

      it "should not make a new place" do
        lambda do
          visit new_place_path
          fill_in :place_title, :with => ""
          fill_in :place_position, :with => ""
          fill_in :place_url, :with => ""
          click_button
          response.should have_selector("div#error_explanation")
        end.should_not change(Place, :count)
      end
    end

    describe "success" do

      it "should make a new place" do
        title = "Lorem ipsum dolor sit amet"
        position ="+12.34+56.78"
        url = "lorem.com"
        lambda do
          visit new_place_path
          fill_in :place_title, :with => title
          fill_in :place_position, :with => position
          fill_in :place_url, :with => url
          click_button
          response.should have_selector("div.place_name", :content => title)
        end.should change(Place, :count).by(1)
      end
    end
  end
end
