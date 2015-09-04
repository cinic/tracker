class CreateModesThirtyMinutes < ActiveRecord::Migration
  def change
    create_table :modes_thirty_minutes do |t|
      t.datetime :time
      t.integer :norm
      t.integer :idle
      t.integer :acl
      t.integer :fail
      t.float :duration_idle
      t.float :duration_norm
      t.float :duration_acl
      t.float :duration_fail
      t.string :packets
      t.references :device, index: true

      t.timestamps
    end
  end
end
