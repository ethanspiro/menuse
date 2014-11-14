require 'openssl'
require 'geokit'

class Location < ActiveRecord::Base
  # Remember to create a migration!

  belongs_to :restaurant
  validates :restaurant_id, presence: true

  before_validation :geocode_that_bitch

  def geocode_that_bitch
    temp = Geokit::Geocoders::GoogleGeocoder.geocode(self.address)
    temp = temp.ll.split(",")
    self.latitude = temp[0]
    self.longitude = temp[1]
  end

end