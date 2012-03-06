class Place < ActiveRecord::Base
  include SocialStream::Models::Object

#  belongs_to :address

  validates :title, :presence => true
  validates :position, :presence => true

end
