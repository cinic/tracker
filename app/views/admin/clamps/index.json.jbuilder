json.array!(@admin_operational_data_devices) do |admin_operational_data_device|
  json.extract! admin_operational_data_device, :id
  json.url admin_operational_data_device_url(admin_operational_data_device, format: :json)
end
