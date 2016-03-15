class ChangeColumnInTicket < ActiveRecord::Migration
  def change
    change_column :tickets, :text, :text, null: false
    add_column :tickets, :close, :boolean, default: false
    remove_column :tickets, :open
  end
end
