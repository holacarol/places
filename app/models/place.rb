class Place < ActiveRecord::Base
  include SocialStream::Models::Object

#  belongs_to :address

  validates :title, :presence => true, :length => { :maximum => 50 }
  validates :position, :presence => true

end
