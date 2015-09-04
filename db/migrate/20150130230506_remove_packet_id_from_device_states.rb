class RemovePacketIdFromDeviceStates < ActiveRecord::Migration
  def change
    remove_reference :device_states, :packet
  end
end
