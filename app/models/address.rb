class Address < ActiveRecord::Base
  attr_accessible :streetAddress, :locality, :region, :postalCode, :country
  before_create :set_formatted

  has_many :places

  validates :streetAddress, :presence => true
  validates :locality, :presence => true
  validates :region, :presence => true
  validates :postalCode, :presence => true
  validates :country, :presence => true
  validates_uniqueness_of :streetAddress, :scope => [:locality, :postalCode]


  private
  
    def set_formatted
      self.formatted =	streetAddress + "\n" + 
			postalCode + " " + locality + " (" + region + ")" + "\n" + 
			country
    end

end
