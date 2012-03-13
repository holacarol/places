class Place < ActiveRecord::Base
  include SocialStream::Models::Object
  # Si hacemos accesible solo algunos atributos, poned:
  # attr_accessible :address_attributes, :title, :position, :url, :author_id, :owner_id, :user_author_id, :_relation_ids

  belongs_to :address, :autosave => true
  accepts_nested_attributes_for :address
		#, :reject_if => :all_blank

  validates :title, :presence => true, :length => { :maximum => 50 }
  validates :position, :presence => true

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
    self.valid?
  end

end
