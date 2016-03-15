class Ticket < ActiveRecord::Base
  belongs_to :user
  belongs_to :device

  validates :subject, :text, presence: true
end
