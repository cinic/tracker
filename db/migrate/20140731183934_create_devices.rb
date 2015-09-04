class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.decimal :serial, precision: 15, null: false
      t.string :name, null: false
      t.integer :slot_number, limit: 3
      t.string :normal_cycle
      t.string :material_consumption
      t.string :sensor_readings
      t.string :schedule
      t.integer :interval, null: false
      t.text :description
    end
    add_index :devices, :serial
  end
end
