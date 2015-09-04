class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.datetime :datetime
      t.string :type
      t.references :device, index: true
      t.references :packet, index: true
      t.datetime :created_at
    end
  end
end
