class AddUpdatedAtToPacket < ActiveRecord::Migration
  def change
    add_column :packets, :updated_at, :datetime
  end
end
