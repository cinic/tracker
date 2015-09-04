json.array!(@admin_devices) do |admin_device|
  json.extract! admin_device, :id
  json.url admin_device_url(admin_device, format: :json)
end
