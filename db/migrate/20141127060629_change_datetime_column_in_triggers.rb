class ChangeDatetimeColumnInTriggers < ActiveRecord::Migration
  def change
    change_column :triggers, :datetime, :date
  end
end
