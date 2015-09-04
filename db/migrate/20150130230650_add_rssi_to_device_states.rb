class AddRssiToDeviceStates < ActiveRecord::Migration
  def change
    add_column :device_states, :rssi, :string
  end
end
