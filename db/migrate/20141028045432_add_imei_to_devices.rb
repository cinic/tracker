class AddImeiToDevices < ActiveRecord::Migration
  def change
    remove_column :devices, :serial, :decimal, precision: 15, null: false
    remove_column :devices, :slot_number, :integer, limit: 3, null: false
    remove_column :devices, :normal_cycle, :string
    remove_column :devices, :material_consumption, :string
    remove_column :devices, :interval, :string

    add_column :devices, :imei, :string, null: false
    add_column :devices, :imei_substr, :string, null: false
    add_column :devices, :slot_number, :string, null: false
    add_column :devices, :interval, :string, null: false
    add_column :devices, :normal_cycle, :string, null: false
    add_column :devices, :material_consumption, :string, null: false
    add_column :devices, :created_at, :datetime
    add_column :devices, :updated_at, :datetime
  end
end
