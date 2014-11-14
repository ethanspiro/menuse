require 'bcrypt'

class Restaurant < ActiveRecord::Base
  # Remember to create a migration!

  include BCrypt

  has_many :items
  has_many :locations

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :password, presence: true

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def password
    @password ||= Password.new(password_hash)
  end

end
