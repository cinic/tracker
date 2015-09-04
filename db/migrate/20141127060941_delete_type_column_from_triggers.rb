class DeleteTypeColumnFromTriggers < ActiveRecord::Migration
  def change
    remove_column :triggers, :type, :string
  end
end
