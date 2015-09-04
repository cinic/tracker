class AddValuesToTriggers < ActiveRecord::Migration
  def change
    add_column :triggers, :values, :text, array: true, default: []
    add_index :triggers, :values, using: 'gin'
  end
end
