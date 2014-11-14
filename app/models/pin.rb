class Pin < ActiveRecord::Base
  belongs_to :item
  belongs_to :user

  validates_uniqueness_of :item_id, :scope => :user_id

end