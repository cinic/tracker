class AddUserRefToDevices < ActiveRecord::Migration
  def change
    add_reference :devices, :user, index: true, null: false
  end
end
