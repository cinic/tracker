class CreatePings < ActiveRecord::Migration
  def change
    create_table :pings do |t|
      t.datetime :ping_was
      t.datetime :ping_will
      t.references :device, index: true

      t.timestamps
    end
  end
end
