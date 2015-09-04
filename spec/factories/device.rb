# Read about factories at https://github.com/thoughtbot/factory_girl
hash = {:balance => '16.24', :temp => '27', :v_batt => '3.467',
				:lat => '54.599399', :long => '39.607826', :datetime => 1.day.ago}

FactoryGirl.define do
	factory :device, class: 'Device' do
		imei '123495044433839'
		name 'Device 1'
		imei_substr '495044433839'
		state hash
		slot_number '8'
		interval '3600'
		normal_cycle '60,5'
		material_consumption '80'
		schedule ''
		sensor_readings '20'
		description ''
		user_id 4
		status 'confirmed'
	end
end
