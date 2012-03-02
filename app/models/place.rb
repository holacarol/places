class Place < ActiveRecord::Base
  include SocialStream::Models::Object

#  belongs_to :address

  validates :title, :presence => true
  validates :position, :presence => true
  validates :author_id, :presence => true
  validates :owner_id, :presence => true
  validates :user_author_id, :presence => true

end
