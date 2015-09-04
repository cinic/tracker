class Clamp < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :device

  validates_uniqueness_of :time, scope: [:device_id]

  # TODO: remove after update rails
  # this method added to Rails 4.2
  def self.find_each(options = {})
    if block_given?
      find_in_batches(options) do |records|
        records.each { |record| yield record }
      end
    else
      enum_for :find_each, options do
        options[:start] ? where(table[primary_key].gteq(options[:start])).size : size
      end
    end
  end

  def fill_type(t)
    self.type = t
    save!(validate: false)
  end
end
