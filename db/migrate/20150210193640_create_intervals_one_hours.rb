class CreateIntervalsOneHours < ActiveRecord::Migration
  def change
    create_table :intervals_one_hours do |t|
      t.datetime :time
      t.string :type
      t.string :packets
      t.references :device, index: true

      t.timestamps
    end
  end
end
