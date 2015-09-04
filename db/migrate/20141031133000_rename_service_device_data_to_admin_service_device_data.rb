class RenameServiceDeviceDataToAdminServiceDeviceData < ActiveRecord::Migration
  def change
    rename_table :service_device_data, :admin_service_device_data
  end
end
