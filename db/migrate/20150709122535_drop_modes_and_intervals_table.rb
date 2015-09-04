class DropModesAndIntervalsTable < ActiveRecord::Migration
  def change
    drop_table :modes_one_minutes
    drop_table :modes_five_minutes
    drop_table :modes_thirty_minutes
    drop_table :modes_one_hours
    drop_table :modes_four_hours
    drop_table :modes_one_days
    drop_table :intervals_one_minutes
    drop_table :intervals_five_minutes
    drop_table :intervals_thirty_minutes
    drop_table :intervals_one_hours
    drop_table :intervals_four_hours
    drop_table :intervals_one_days
  end
end
