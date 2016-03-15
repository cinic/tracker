class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :subject
      t.references :user, index: true, foreign_key: true
      t.references :device, index: true, foreign_key: true
      t.text :text
      t.boolean :open

      t.timestamps null: false
    end
  end
end
