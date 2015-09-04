class AddCorrectionToModes < ActiveRecord::Migration
  def change
    add_column :modes_one_minutes, :idle_correction, :float, default: 0.0

    add_column :modes_five_minutes, :idle_correction, :float, default: 0.0

    add_column :modes_thirty_minutes, :idle_correction, :float, default: 0.0

    add_column :modes_one_hours, :idle_correction, :float, default: 0.0

    add_column :modes_four_hours, :idle_correction, :float, default: 0.0

    add_column :modes_one_days, :idle_correction, :float, default: 0.0
  end
end
