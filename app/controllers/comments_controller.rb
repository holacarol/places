class CommentsController < ApplicationController
  include SocialStream::Controllers::Objects

  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  skip_load_and_authorize_resource :only => [:create, :destroy]

  respond_to :json

  def show    
    parent = resource.post_activity.parent
    redirect_to polymorphic_path(parent.direct_object,:anchor => dom_id(parent))
  end

  def create
  	unless params[:comment][:owner_id]
  		params[:comment].merge!(:owner_id => current_subject.try(:actor_id))
  	end
  	create!
  end
end
