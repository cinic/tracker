class FixImeiColumnTypeOperationalDataDevices < ActiveRecord::Migration
  def up
    change_column :admin_operational_data_devices, :imei, :string
  end

  def down
    change_column :admin_operational_data_devices, :imei, :decimal, precision: 15, scale: 0
  end
end
