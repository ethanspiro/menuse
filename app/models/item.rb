class Item < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :restaurant

  has_many :pins
  has_many :users, through: :pins

  validates :title, presence: true
  validates :restaurant_id, presence: true

end
