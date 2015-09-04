class AddDefaultIdleValues < ActiveRecord::Migration
  def change
    change_column :modes_one_minutes, :duration_idle, :float, default: 60.0
  end
end
