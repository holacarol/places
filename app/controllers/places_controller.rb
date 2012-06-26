class PlacesController < ApplicationController
  include SocialStream::Controllers::Objects
  
  skip_authorize_resource :only => [:new, :discover]
  skip_load_resource :only => :discover

  belongs_to_subjects :optional => true

  before_filter :profile_subject!, :only => [:index, :discover]

  PER_PAGE = 20

  def index
    index! do |format|
      format.html {
        @places = Array.new
        collection.each do |a|
          @places << a.activity_objects.first.place
        end
        @json = @places.to_gmaps4rails
      }
    end
  end

  def show
    show! do |format|
      format.html {
        @json = @place.to_gmaps4rails
      }
    end
  end


  def discover
    @json = Place.all.to_gmaps4rails
  end




  private

    def collection
      @activities =
        profile_subject.wall(:profile,
			     :for => current_subject,
			     :object_type => :Place)
    end

    def friends_places

    end

end
