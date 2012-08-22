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

    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.js
        format.json {
          image_url = root_url.end_with?("/")? root_url[0, root_url.length-1] : root_url
          render :json => {
            :comment =>
            {'author' => @comment.author,
            'thumb' => image_url + @comment.author.logo.url(:actor),
            'text' => @comment.description,
            'type' => @comment.post_activity.from_contact?(current_subject) ? 'friend' : 'other'}
            }, :status => :created, :callback => params[:callback]
        }
      else
        format.js
        format.json { render :json => {:success => false, :errors => @comment.errors}, :status => :unprocessable_entity }
      end
    end


  end
end
