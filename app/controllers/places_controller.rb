class PlacesController < ApplicationController
  include SocialStream::Controllers::Objects
  
  skip_authorize_resource :only => [:new, :map]
  skip_load_resource :only => :map

  belongs_to_subjects :optional => true

  before_filter :profile_subject!, :only => [:index, :map]

  PER_PAGE = 20


  def map
    @places = Array.new
    collection.each do |a|
      @places << a.activity_objects.first.place
    end
    @json = @places.to_gmaps4rails
  end

  def discover

  end




  private

    def collection
      @activities =
        profile_subject.wall(:profile,
			     :for => current_subject,
			     :object_type => :Place)
    end

end
