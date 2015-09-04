class RemoveTimestampsFromOperationalDataDevices < ActiveRecord::Migration
  def change
    remove_column :operational_data_devices, :created_at, :string
    remove_column :operational_data_devices, :updated_at, :string
  end
end
