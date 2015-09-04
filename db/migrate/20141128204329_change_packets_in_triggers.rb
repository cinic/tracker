class ChangePacketsInTriggers < ActiveRecord::Migration
  def change
    add_column :triggers, :packets, :text, array: true, default: []
    add_index :triggers, :packets, using: 'gin'
  end
end
