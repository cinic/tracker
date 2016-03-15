class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name, null: false
      t.string :contact, null: false
      t.references :user, index: true, foreign_key: true
      t.string :comment

      t.timestamps null: false
    end
  end
end
