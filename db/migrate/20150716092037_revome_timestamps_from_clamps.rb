class RevomeTimestampsFromClamps < ActiveRecord::Migration
  def change
    remove_column :clamps, :created_at, :datetime
    remove_column :clamps, :updated_at, :datetime
  end
end
