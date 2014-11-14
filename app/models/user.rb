require 'bcrypt'

class User < ActiveRecord::Base

  include BCrypt

  has_many :pins
  has_many :items, through: :pins

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :username, presence: true, uniqueness: true

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def password
    @password ||= Password.new(password_hash)
  end

end
