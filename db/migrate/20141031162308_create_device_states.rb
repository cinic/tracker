class CreateDeviceStates < ActiveRecord::Migration
  def change
    create_table :device_states do |t|
      t.string :sim_balance
      t.integer :temp, limit: 3
      t.string :v_batt
      t.string :gis
      t.datetime :datetime
      t.references :device, index: true
      t.references :packet, index: true
      t.datetime :created_at
    end
  end
end
