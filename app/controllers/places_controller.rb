class PlacesController < ApplicationController
  include SocialStream::Controllers::Objects
  
  skip_authorize_resource :only => :new

  belongs_to_subjects :optional => true

  before_filter :profile_subject!, :only => :index

  PER_PAGE = 20


  def index
    index! do |format|
      @places_pag = Kaminari.paginate_array(@places).page(params[:page]).per(5)
      @friends = friends_places
      @recommended = current_subject.recommendations
      format.html {
        @places_json = @places.to_gmaps4rails do |place, marker|
          marker.picture({
                  :picture => "/assets/mapmarker22x32.png",
                  :width   => 22,
                  :height  => 32,
                  :shadow_picture => "/assets/shadow32x32.png",
                  :shadow_width => 32,
                  :shadow_height => 32,
                  :shadow_anchor => [11, 32]
                 })
          marker.title   place.title
          marker.infowindow render_to_string(:partial => "/places/place_window", :locals => { :place => place })
        end
        @friends_json = @friends.to_gmaps4rails do |place, marker|
          marker.picture({
                  :picture => "/assets/greenmarker22x32.png",
                  :width   => 22,
                  :height  => 32,
                  :shadow_picture => "/assets/shadow32x32.png",
                  :shadow_width => 32,
                  :shadow_height => 32,
                  :shadow_anchor => [11, 32]
                 })
          marker.title   place.title
          marker.infowindow render_to_string(:partial => "/places/place_window", :locals => { :place => place })
        end
        @recommended_json = @recommended.to_gmaps4rails do |place, marker|
          marker.picture({
                  :picture => "/assets/borderorangemarker22x32.png",
                  :width   => 22,
                  :height  => 32,
                  :shadow_picture => "/assets/shadow32x32.png",
                  :shadow_width => 32,
                  :shadow_height => 32,
                  :shadow_anchor => [11, 32]
                 })
          marker.title   place.title
          marker.infowindow render_to_string(:partial => "/places/place_window", :locals => { :place => place })
        end
      }
      format.json { 
        @places.map{|place|
        place.current_subject = current_subject}

        @friends.map{|place|
        place.current_subject = current_subject}

        @recommended.map{|place|
        place.current_subject = current_subject}

        if profile_subject_is_current?
          render :json => {:myplaces => @places, :friends => @friends, :recommended => @recommended}, :callback => params[:callback]
        else
          render :json => @places, :callback => params[:callback]
        end
      }
    end
  end

  def show
    if (@place.latitude == 0 && @place.longitude == 0) 
      if @place.geocode_address
        @place.update_column(:latitude, @place.latitude)
        @place.update_column(:longitude, @place.longitude)
      end
    end
    show! do |format|
      format.html {
        @json = @place.to_gmaps4rails
      }
      format.json { 
        @place.current_subject = current_subject
        render :json => {
        :place => @place, 
        :comments => @place.post_activity.comments.map{ |activity| 
          {'author' => activity.direct_activity_object.author,
          'thumb' => root_url + activity.direct_activity_object.author.logo.url(:actor),
          'text' => activity.direct_activity_object.description,
          'type' => activity.from_contact?(current_subject) ? 'friend' : 'other'}
          }
        }, :callback => params[:callback] 
      }
    end
  end

  def create
    create! do |success, failure|
      success.html {
        @like = Like.build(current_subject, current_user, @place.post_activity)
        current_subject.actor.like @place
        @like.save
        redirect_to @place
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