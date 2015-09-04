class CreateIntervalsThirtyMinutes < ActiveRecord::Migration
  def change
    create_table :intervals_thirty_minutes do |t|
      t.datetime :time
      t.string :type
      t.string :packets
      t.references :device, index: true

      t.timestamps
    end
  end
end
