class User < ActiveRecord::Base
  has_many :devices, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :timeoutable, :validatable

  validates_presence_of :name
  validates_confirmation_of :password, if: :revalid

  def revalid
    false
  end
end