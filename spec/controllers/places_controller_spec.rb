require 'spec_helper'

describe PlacesController do
  render_views

  before do
    @place = Factory(:place)
  end

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
	response.should redirect_to(new_user_session_path)
      end
    end

    describe "for signed-in users" do

      before(:each) do
	@user = Factory(:user)
	sign_in @user
      end

      it "should be successful" do
        get :index, :user_id => @place.post_activity.receiver.to_param
	response.should be_success
      end

      it "should have an element for each place" do
        get :index, :user_id => @place.post_activity.receiver.to_param
	response.should be_success
	#response.body.should =~
	#response.body.should =~
      end
    end
  end

  describe "POST 'create'" do

    describe "access control" do
      it "should deny access to 'create'" do
        post :create
        response.should redirect_to(new_user_session_path)
      end  
    end

    describe "for signed-in users" do

      before(:each) do
        @user = Factory(:user)
	sign_in @user
      end

      describe "failure" do

        before(:each) do
          @attr = {
		:title => "",
		:position => "",
		:url => "",
		:author_id => @user.id ,
		:owner_id => @user.id,
		:user_author_id => @user.id }
        end

        it "should not create a place" do
	  lambda do
	    post :create, :place => @attr
          end.should_not change(Place, :count)
	end

#        it "should render the home page" do
#	  post :create, :place => @attr
#	  response.should render_template('pages/home')
#	 end
      end

      describe "success" do

        before(:each) do
          @attr = {
		:title => "Test place",
		:position => "+48.8577+002.295",
		:url => "http://www.testplace.com",
		:author_id => @user.id ,
		:owner_id => @user.id,
		:user_author_id => @user.id }
	end

        it "should create a place" do
	  lambda do
	    post :create, :place => @attr
          end.should change(Place, :count).by(1)
        end

#        it "should redirect to the home page" do
#	  post :create, :place => @attr
#          response.should redirect_to(root_path)
#	end

#        it "should have a flash message" do
#	  post :create, :place => @attr
#	  flash[:success].should =~ /place created/i
#	end
      end
    end
  end
end
