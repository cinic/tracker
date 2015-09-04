class RenamePacketIdInTriggers < ActiveRecord::Migration
  def change
    remove_reference :triggers, :packet, index: true
  end
end
