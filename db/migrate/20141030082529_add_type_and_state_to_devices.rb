class AddTypeAndStateToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :state, :json
    add_column :devices, :device_type, :string
  end
end
