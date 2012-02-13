class Address < ActiveRecord::Base

  validates :streetAddress, :presence => true
  validates :locality, :presence => true
  validates :postalCode, :presence => true
  validates :country, :presence => true
  validates_uniqueness_of :streetAddress, :scope => [:locality, :postalCode]


end
