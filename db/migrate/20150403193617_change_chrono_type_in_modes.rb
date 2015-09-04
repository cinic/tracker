class ChangeChronoTypeInModes < ActiveRecord::Migration
  def change
    change_column :modes_one_minutes, :chrono_type, :string, default: ''

    change_column :modes_five_minutes, :chrono_type, :string, default: ''

    change_column :modes_thirty_minutes, :chrono_type, :string, default: ''

    change_column :modes_one_hours, :chrono_type, :string, default: ''

    change_column :modes_four_hours, :chrono_type, :string, default: ''

    change_column :modes_one_days, :chrono_type, :string, default: ''
  end
end
