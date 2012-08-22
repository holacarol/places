class LikesController < ApplicationController
  before_filter :authenticate_user!, :indirect_object
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # POST /activities/1/like.js
  def create
    @like = Like.build(current_subject, current_user, @indirect_id)
    
    respond_to do |format|
      status = @like.save
      if status
        if (@indirect_id.direct_object.present? && @indirect_id.direct_object.is_a?(Place))
          current_subject.actor.like @indirect_id.direct_object
        end
      end

      format.js {
        format.js
      }
      format.json {
        if status
          render :json => {:success => true} , :callback => params[:callback]
        else
          render :json => {:success => false} , :callback => params[:callback]
        end
      }
    end
  end

  # DELETE /activities/1/like.js
  def destroy
    @like = Like.find!(current_subject, @indirect_id)
    
    respond_to do |format|
      status = @like.destroy
      if status
        if (@indirect_id.direct_object.present? && @indirect_id.direct_object.is_a?(Place))
          current_subject.actor.unlike @indirect_id.direct_object
        end
      end

      format.js {
        format.js
      }
      format.json {
        if status
          render :json => {:success => true} , :callback => params[:callback]
        else
          render :json => {:success => false} , :callback => params[:callback]
        end
      }
    end
  end
  
  private
  
  def indirect_object
    if params[:activity_id].present?
     @indirect_id = Activity.find(params[:activity_id])
    elsif params[:user_id].present?
     @indirect_id = User.find_by_slug!(params[:user_id])
    elsif params[:group_id].present?
     @indirect_id = Group.find_by_slug!(params[:group_id])
    end
  end
end
