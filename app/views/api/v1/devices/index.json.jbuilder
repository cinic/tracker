json.array! @devices do |device|
  json.id device.id
  json.status device.status
  json.name device.name
  json.slot_number device.slot_number
  json.normal_cycle device.normal_cycle
  json.material_consumption device.material_consumption
  json.sensor_readings device.sensor_readings
  json.schedule device.schedule
  json.interval device.interval
  json.state device.states.last
  json.ping device.pings.last
end
