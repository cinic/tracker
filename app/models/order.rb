class Order < ActiveRecord::Base
  STATUSES = %w(new in_progress done cancelled).freeze

  belongs_to :user
  after_initialize :prepare_status

  validates :name, :contact, presence: true
  validates :status, inclusion: { in: STATUSES }

  private

  def prepare_status
    return unless new_record?
    self.status = STATUSES[0]
  end
end
