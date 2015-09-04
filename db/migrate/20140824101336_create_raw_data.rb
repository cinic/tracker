class CreateRawData < ActiveRecord::Migration
  def change
    create_table :raw_data do |t|
      t.decimal :imei, precision: 15, null: false
      t.text :content
      t.datetime :datetime

      t.timestamps
    end
    add_index :raw_data, :imei
  end
end
