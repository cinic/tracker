class CreateOperationalDataDevices < ActiveRecord::Migration
  def change
    create_table :operational_data_devices do |t|
      t.decimal :imei, precision: 15, scale: 0
      t.references :device, index: true
      t.datetime :datetime
      t.references :raw_data, index: true

      t.timestamps
    end
    add_index :operational_data_devices, :imei
  end
end
