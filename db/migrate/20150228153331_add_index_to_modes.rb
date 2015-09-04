class AddIndexToModes < ActiveRecord::Migration
  def change
    add_index :modes_one_minutes, :time

    add_index :modes_five_minutes, :time

    add_index :modes_thirty_minutes, :time

    add_index :modes_one_hours, :time

    add_index :modes_four_hours, :time

    add_index :modes_one_days, :time
  end
end
