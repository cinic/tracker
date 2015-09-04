class RenameDeviceStateToState < ActiveRecord::Migration
  def change
    rename_table :device_states, :states
  end
end
