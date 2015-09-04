class AddPacketIdToClamp < ActiveRecord::Migration
  def change
    add_reference :clamps, :packet, index: true
  end
end
