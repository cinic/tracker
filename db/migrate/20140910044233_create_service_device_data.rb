class CreateServiceDeviceData < ActiveRecord::Migration
  def change
    create_table :service_device_data do |t|
      t.decimal :sim_balance, precision: 11, scale: 2
      t.string :hw_ver
      t.integer :v_batt
      t.decimal :imei, precision: 15, scale: 0
      t.integer :temp
      t.datetime :date
      t.integer :switch_on_init
      t.integer :switch_on_num
      t.integer :data_type
      t.string :fw_ver
      t.integer :item_errors
      t.integer :satellite
      t.string :hdo
      t.string :log
      t.decimal :rssi, precision: 6, scale: 0
      t.integer :bss, limit: 2
      t.text :gsm_data

      t.timestamps
    end
    add_index :service_device_data, :imei
  end
end
