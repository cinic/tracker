class CreateIntervalsFourHours < ActiveRecord::Migration
  def change
    create_table :intervals_four_hours do |t|
      t.datetime :time
      t.string :type
      t.string :packets
      t.references :device, index: true

      t.timestamps
    end
  end
end
