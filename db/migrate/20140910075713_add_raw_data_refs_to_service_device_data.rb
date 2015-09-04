class AddRawDataRefsToServiceDeviceData < ActiveRecord::Migration
  def change
    add_reference :service_device_data, :raw_data, index: true
  end
end
