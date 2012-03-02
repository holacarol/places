require 'spec_helper'

describe PlacesController do
  render_views

  before do
    @place = Factory(:place)
  end

  describe "GET 'index'" do

    describe "for non-signer-in users" do
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
end
