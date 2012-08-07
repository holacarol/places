class Place < ActiveRecord::Base
  include SocialStream::Models::Object
  # Si hacemos accesible solo algunos atributos, poned:
  #attr_accessible :address_attributes, :title, :latitude, :longitude, :url, :phone_number, :author_id, :owner_id, :user_author_id, :relation_ids

  attr_accessor :current_subject

  belongs_to :address, :autosave => true
  accepts_nested_attributes_for :address
		#, :reject_if => :all_blank

  before_save :format_website

  acts_as_mappable  :lat_column_name => :latitude,
                    :lng_column_name => :longitude

  #before_validation :geocode_address, :on => :create

  acts_as_gmappable :process_geocoding => false

  validates :title, :presence => true, :length => { :maximum => 50 }
  validates :latitude, :presence => true
  validates :longitude, :presence => true

  # Sphinx search
  define_index do
    # fields
    indexes activity_object.title, :as => :title, :sortable => true
    indexes address.locality
    indexes address.region
    indexes address.country
    # attributes
    has activity_object.like_count, :as => :like_count
  end

  # Solution to the problem: If place already exists, get the associated id.
  # Other solution to consider: Find the existing place in the controller or not use the nested_attributes

  # If you need to validate the associated record, you can add a method like this:
  #def validate_associated_records_for_address
  #  if address.streetAddress.blank?
  #    errors.add(:streetAddress, "can't be empty")
  #  end
  #  if place.googleid.blank?
  #    errors.add(:googleid, "can't be empty")
  #  end
  #  if place.googleref.blank?
  #    errors.add(:googleref, "can't be empty")
  #  end
  #  if place.name.blank?
  #    errors.add(:name, "can't be empty")
  #  end
  #end
    

  def autosave_associated_records_for_address
    if new_address = Address.find_by_streetAddress_and_locality(address.streetAddress, address.locality) then
      self.address = new_address
    else
      self.address.save!
      self.address_id = address.id
    end
    if (self.latitude == 0 && self.longitude == 0)
      geocode_address
    end
    self.valid?
  end

  # Subject's friends who like this place
  def friends(subject)
    friends = Set.new
    # Total number of likes of the place, including me
    likes = self.post_activity.children.joins(:activity_verb).where('activity_verbs.name' => "like")
    friend_likes = likes.joins(:channel).joins('INNER JOIN contacts ON contacts.receiver_id = channels.author_id').
      where('contacts.sender_id' => subject).where('contacts.ties_count' => 1)
    friend_likes.each do |a|
      friends << a.sender
    end
    friends
  end

  def geocode_address
#    puts self.address.formatted
#    puts CGI.escape(self.address.formatted)
    geo=Geokit::Geocoders::MultiGeocoder.geocode(self.address.formatted)
#    if geo.success
#      puts geo.lat
#      puts geo.lng
#      puts geo.full_address
#    else
#      puts "Geocode failure"
#    end
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.latitude, self.longitude = geo.lat,geo.lng if geo.success
    geo.success
  end

  def as_json(options={})
    super(
      :except => [:activity_object_id, :address_id, :created_at, :updated_at],
      :include => {
        :address => {}},
      :methods => [:title, :is_liked, :post_activity_id]
    )
  end

  def is_liked
    self.post_activity.liked_by?(current_subject)
  end

  def post_activity_id
    self.post_activity.id
  end

  protected
  def format_website
    if self.url.present? && !self.url.start_with?("http://")
      self.url = "http://" + self.url
    end
  end


end
