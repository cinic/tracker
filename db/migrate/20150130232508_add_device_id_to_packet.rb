class AddDeviceIdToPacket < ActiveRecord::Migration
  def change
    add_reference :packets, :device, index: true
  end
end
