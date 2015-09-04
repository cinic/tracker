class CreateAdminAdmins < ActiveRecord::Migration
  def change
    create_table :admin_admins do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_salt, null: false
      t.string :password_hash, null: false
      t.string :role, null: false, default: 1
      t.string :remember_token

      t.timestamps
    end
    add_index :admin_admins, :email, unique: true
  end
end
