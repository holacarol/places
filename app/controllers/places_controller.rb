class PlacesController < ApplicationController
  include SocialStream::Controllers::Objects
  
  skip_authorize_resource :only => :new

  belongs_to_subjects :optional => true

  before_filter :profile_subject!, :only => :index

  PER_PAGE = 20

  private

    def collection
      @activities =
        profile_subject.wall(:profile,
			     :for => current_subject,
			     :object_type => :Place)
    end

end
