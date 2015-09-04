class AddSimBalanceToRawData < ActiveRecord::Migration
  def change
    add_column :raw_data, :sim_balance, :string
  end
end
