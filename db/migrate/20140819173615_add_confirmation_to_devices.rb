class AddConfirmationToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :status, :string, default: 'new'
    add_index :devices, :status
  end
end
