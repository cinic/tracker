class Device < ActiveRecord::Base
  include ActiveModel::Dirty
  default_scope -> { order(id: :asc) }
  has_many :packets, dependent: :destroy
  has_many :states, dependent: :destroy
  has_many :pings, dependent: :destroy
  has_many :clamps, dependent: :destroy
  belongs_to :user

  validates :interval,
            :imei,
            :material_consumption,
            :normal_cycle,
            :user_id, presence: true
  validates :imei, uniqueness: true, length: { is: 15 }, format: { with: /[0-9]/ }
  validates :name, presence: true, length: { maximum: 60 }
  validates :slot_number, numericality: { less_than_or_equal_to: 200 }
  validates :material_consumption, numericality: { greater_than: 0 }
  validates :sensor_readings, numericality: { greater_than: 0 }, allow_blank: true

  before_save :prepare_imei
  before_save :refill_types, if: :check_record
  after_update :send_params

  def min_cycle
    normal_cycle.split(/[ ,\,:;]/).first.to_f - normal_cycle.split(/[ ,\,:;]/).last.to_f
  end

  def max_cycle
    normal_cycle.split(/[ ,\,:;]/).first.to_f + normal_cycle.split(/[ ,\,:;]/).last.to_f
  end

  def idle
    [300.0, max_cycle * 5]
  end

  def check_type(duration)
    if duration <= max_cycle && duration >= min_cycle
      'norm'
    elsif duration < min_cycle
      'acl'
    elsif duration >= idle[0] && duration >= idle[1]
      'idle'
    elsif duration < idle[0] && duration > max_cycle
      'fail'
    end
  end

  def interval_in_seconds
    interval.to_i * 60
  end

  private

  def prepare_imei
    self.imei_substr = imei[3..15]
  end

  def send_params
    return true if Rails.env.development?
    params = { command: 'check', number: imei_substr,
               interval: interval, gps: 0 }
    uri = URI.parse(APP_CONFIG['zanoza_url'])
    uri.query = URI.encode_www_form(params)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(APP_CONFIG['zanoza_login'], APP_CONFIG['zanoza_pass'])
    http.request(request)
  end

  def check_record
    !self.new_record? && self.normal_cycle_changed?
  end

  def refill_types
    Delayed::Job.enqueue(
      PacketProcess::TypesJob.new(id, true),
      queue: 'intervals',
      run_at: 1.minutes.from_now
    )
  end
end
