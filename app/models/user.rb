class User < ActiveRecord::Base
  has_many :devices, dependent: :destroy
  has_many :tickets, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :timeoutable, :validatable

  validates :name, presence: true
  validates :password, confirmation: true, if: :revalid
  validates :company, presence: true

  def slim_devices
    devices.select([:id, :name, :state, :device_type, :imei])
  end

  def time_zone
    ActiveSupport::TimeZone.find_tzinfo(self[:time_zone]).identifier
  end

  def raw_tz
    self[:time_zone]
  end

  private

  def revalid
    false
  end
end
