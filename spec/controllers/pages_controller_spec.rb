require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :home
        response.should redirect_to(new_user_session_path)
        flash[:alert].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end

      it "should be successful" do
        get :home
        response.should be_success
      end

      it "should have the right title" do
        get :home
        response.should have_selector("title",
                        :content => "Places App | Home")
      end
    end
  end

  describe "GET 'contact'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :contact
        response.should redirect_to(new_user_session_path)
        flash[:alert].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end

      it "should be successful" do
        get :contact
        response.should be_success
      end

      it "should have the right title" do
        get :contact
        response.should have_selector("title",
                        :content => "Places App | Contact")
      end
    end
  end

  describe "GET 'about'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :about
        response.should redirect_to(new_user_session_path)
        flash[:alert].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end

      it "should be successful" do
        get :about
        response.should be_success
      end

      it "should have the right title" do
        get :about
        response.should have_selector("title",
                        :content => "Places App | About")
      end
    end
  end

end
