class AddTimeStampsToClamps < ActiveRecord::Migration
  def change
    add_column :clamps, :created_at, :datetime
    add_column :clamps, :updated_at, :datetime
  end
end
