class DropTableServiceDeviceData < ActiveRecord::Migration
  def change
    drop_table :admin_service_device_data
  end
end
