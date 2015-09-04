class ChangeVBattColumnType < ActiveRecord::Migration
  def up
    change_column :service_device_data, :v_batt, :decimal, precision: 9, scale: 4, default: 0.0
  end

  def down
    change_column :service_device_data, :v_batt, :integer
  end
end
