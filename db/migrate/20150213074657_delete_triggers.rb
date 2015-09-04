class DeleteTriggers < ActiveRecord::Migration
  def change
    drop_table :triggers
  end
end
