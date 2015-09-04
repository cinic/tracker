class RemoveDataDevice < ActiveRecord::Migration
  def change
    drop_table :data_devices
  end
end
