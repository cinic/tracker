json.array!(@admin_service_device_data) do |admin_service_device_datum|
  json.extract! admin_service_device_datum, :id
  json.url admin_service_device_datum_url(admin_service_device_datum, format: :json)
end
