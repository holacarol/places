class Place < ActiveRecord::Base
  include SocialStream::Models::Object
  # Si hacemos accesible solo algunos atributos, poned:
  # attr_accessible :address_attributes, :title, :latitude, :longitude, :url, :author_id, :owner_id, :user_author_id, :relation_ids

  belongs_to :address, :autosave => true
  accepts_nested_attributes_for :address
		#, :reject_if => :all_blank

  acts_as_mappable  :lat_column_name => :latitude,
                    :lng_column_name => :longitude

  #before_validation :geocode_address, :on => :create

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
    geocode_address
    self.valid?
  end

  private
  def geocode_address
#    puts self.address.formatted
    geo=Geokit::Geocoders::MultiGeocoder.geocode (self.address.formatted)
#    if geo.success
#      puts geo.lat
#      puts geo.lng
#      puts geo.full_address
#    else
#      puts "Geocode failure"
#    end
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.latitude, self.longitude = geo.lat,geo.lng if geo.success
  end

end
