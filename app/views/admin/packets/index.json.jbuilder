json.array!(@admin_data_devices) do |admin_data_device|
  json.extract! admin_data_device, :id
  json.url admin_data_device_url(admin_data_device, format: :json)
end
