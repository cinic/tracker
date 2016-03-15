class Device < ActiveRecord::Base
  default_scope -> { order(id: :desc) }
  scope :confirmed, -> { where(status: 'confirmed') }
  scope :unconfirmed, -> { where(status: 'new') }

  DATA_TRANSFER_FREQUENCY = [
    [(I18n.translate 'datetime.distance_in_words.x_minutes', count: 2), 2],
    [(I18n.translate 'datetime.distance_in_words.x_minutes', count: 15), 15],
    [(I18n.translate 'datetime.distance_in_words.x_minutes', count: 30), 30],
    [(I18n.translate 'datetime.distance_in_words.x_hours', count: 1), 60],
    [(I18n.translate 'datetime.distance_in_words.x_hours', count: 2), 120],
    [(I18n.translate 'datetime.distance_in_words.x_hours', count: 6), 360],
    [(I18n.translate 'datetime.distance_in_words.x_hours', count: 12), 720],
    [(I18n.translate 'datetime.distance_in_words.x_hours', count: 24), 1440],
    [(I18n.translate 'datetime.distance_in_words.x_hours', count: 48), 2880],
    [(I18n.translate 'datetime.distance_in_words.x_hours', count: 72), 4320]
  ].freeze

  CYCLE_TYPES = %w(acl fail idle norm).freeze

  include ActiveModel::Dirty

  has_many :packets, dependent: :destroy
  has_many :states, dependent: :destroy
  has_many :pings, dependent: :destroy
  has_many :clamps, dependent: :destroy
  belongs_to :user

  validates :interval,
            :imei,
            :material_consumption,
            :min_cycle,
            :max_cycle,
            :user_id, presence: true
  validates :imei, uniqueness: true,
                   length: { is: 15 }, format: { with: /[0-9]/ }
  validates :name, presence: true, length: { maximum: 60 }
  validates :slot_number, numericality: { only_integer: true,
                                          less_than_or_equal_to: 200,
                                          greater_than: 0 }
  validates :material_consumption, numericality: { greater_than: 0 }
  validates :min_cycle, numericality: { greater_than: 2 }
  validates :max_cycle,
            numericality: { greater_than: 2,
                            greater_than_or_equal_to: :check_min_cycle }
  validates :sensor_readings,
            numericality: { greater_than: 0 }, allow_blank: true

  before_save :prepare_imei, :prepare_cycles
  before_save :refill_types, if: :check_record
  after_update :send_params
  after_find :check_state

  def idle
    [300.0, max_cycle.to_f * 5]
  end

  def check_type(duration)
    if duration <= max_cycle.to_f && duration >= min_cycle.to_f
      'norm'
    elsif duration < min_cycle.to_f
      'acl'
    elsif duration >= idle[0] && duration >= idle[1]
      'idle'
    elsif duration < idle[0] && duration > max_cycle.to_f
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

  def prepare_cycles
    self.min_cycle = min_cycle.to_f
    self.max_cycle = max_cycle.to_f
    self.normal_cycle = ((min_cycle.to_f + max_cycle.to_f) / 2).to_f
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
    !new_record? && (min_cycle_changed? || max_cycle_changed?)
  end

  def check_state
    ls = states.order(datetime: :desc).first
    self[:state] = (ls.nil? ? State.new.attributes : ls.attributes)
  end

  def check_min_cycle
    min_cycle.to_i
  end

  def refill_types
    Delayed::Job.enqueue(
      PacketProcess::TypesCleanJob.new(id, true),
      queue: 'intervals',
      run_at: 1.minutes.from_now
    )
  end
end
