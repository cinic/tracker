class RenameDatetimeInTriggers < ActiveRecord::Migration
  def change
    rename_column :triggers, :datetime, :date
  end
end
