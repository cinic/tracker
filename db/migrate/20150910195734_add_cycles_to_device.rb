class AddCyclesToDevice < ActiveRecord::Migration
  def up
    add_column :devices, :min_cycle, :string
    add_column :devices, :max_cycle, :string
    change_column :devices, :normal_cycle, :string, null: true
    
    Device.find_each do |device|
      device.min_cycle = device.min_cycle
      device.max_cycle = device.max_cycle
      device.save!
    end
  end
  
  def down
    remove_column :devices, :min_cycle
    remove_column :devices, :max_cycle
    change_column :devices, :normal_cycle, :string, null: false
  end
end
