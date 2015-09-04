class ChangeCorrectionColumnNameInModes < ActiveRecord::Migration
  def change
    rename_column :modes_one_minutes, :idle_correction, :chrono_type

    rename_column :modes_five_minutes, :idle_correction, :chrono_type

    rename_column :modes_thirty_minutes, :idle_correction, :chrono_type

    rename_column :modes_one_hours, :idle_correction, :chrono_type

    rename_column :modes_four_hours, :idle_correction, :chrono_type

    rename_column :modes_one_days, :idle_correction, :chrono_type
  end
end
