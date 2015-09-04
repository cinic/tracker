class AddDefaultValuesToIntervals < ActiveRecord::Migration
  def change
    change_column :intervals_one_minutes, :type, :string, default: 'idle'

    change_column :intervals_five_minutes, :type, :string, default: 'idle'

    change_column :intervals_thirty_minutes, :type, :string, default: 'idle'

    change_column :intervals_one_hours, :type, :string, default: 'idle'

    change_column :intervals_four_hours, :type, :string, default: 'idle'

    change_column :intervals_one_days, :type, :string, default: 'idle'
  end
end
