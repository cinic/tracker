class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :role, null: false, default: 1
      t.string :company

      t.timestamps
    end
  end
end
