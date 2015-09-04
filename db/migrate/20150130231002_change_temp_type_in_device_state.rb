class ChangeTempTypeInDeviceState < ActiveRecord::Migration
  def change
    change_column :device_states, :temp, :string
  end
end
