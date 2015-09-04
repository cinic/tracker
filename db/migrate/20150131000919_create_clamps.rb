class CreateClamps < ActiveRecord::Migration
  def change
    create_table :clamps do |t|
      t.datetime :time
      t.string :duration
      t.string :type
      t.references :device, index: true

      t.timestamps
    end
    add_index :clamps, :time
  end
end
