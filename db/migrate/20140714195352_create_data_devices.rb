class CreateDataDevices < ActiveRecord::Migration
  def change
    create_table :data_devices do |t|
      t.datetime :date, null: false
      t.string :packet_type, null: false
      t.text :content, null: false
      t.boolean :processed, null: false
      t.references :device, index: true, null: false

      t.timestamps
    end
  end
end
