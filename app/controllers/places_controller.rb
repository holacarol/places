class PlacesController < ApplicationController
  include SocialStream::Controllers::Objects
  
  skip_authorize_resource :only => :new

  belongs_to_subjects :optional => true

  before_filter :profile_subject!, :only => :index

  PER_PAGE = 20

  def index
    index! do |format|
      format.html {
        @friends = friends_places
        @places_json = @places.to_gmaps4rails
        @friends_json = @friends.to_gmaps4rails
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


  private

    def collection
      @activities =
        profile_subject.wall(:profile,
			     :for => current_subject,
			     :object_type => :Place)
      @places = Array.new
      @activities.each do |a|
        @places << a.activity_objects.first.place
      end
    end

    def friends_places
    #Likes from my friends
    #likes = Activity.joins(:activity_verb).where('activity_verbs.name' => "like").
    # joins(:channel).joins('INNER JOIN contacts ON contacts.receiver_id = channels.author_id').
    # where('contacts.sender_id' => current_subject).where('contacts.ties_count' => 1)

      Place.select("DISTINCT places.*").
      joins(:activity_object).
      joins('INNER JOIN activity_object_activities ON activity_object_activities.activity_object_id = activity_objects.id').
      joins('INNER JOIN activities ON activities.id = activity_object_activities.activity_id').
      joins('INNER JOIN activity_verbs ON activity_verbs.id = activities.activity_verb_id').
      where('activity_verbs.name' => "like").
      joins('INNER JOIN channels ON channels.id = activities.channel_id').
      joins('INNER JOIN contacts ON contacts.receiver_id = channels.author_id').
      where('contacts.sender_id' => current_subject).where('contacts.ties_count' => 1)
  end

end