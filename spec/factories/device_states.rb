# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :state do
    sim_balance '3.18'
    temp '10'
    v_batt '3.800'
    gis '39.607826, 54.599399'
    datetime 1.day.ago
    device_id nil
    created_at '2014-10-31 19:23:08'
    rssi '22'
  end
end
