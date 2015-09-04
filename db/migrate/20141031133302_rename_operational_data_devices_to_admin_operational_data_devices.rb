class RenameOperationalDataDevicesToAdminOperationalDataDevices < ActiveRecord::Migration
  def change
    rename_table :operational_data_devices, :admin_operational_data_devices
  end
end
