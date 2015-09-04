class AddDetailsToAdminAdmins < ActiveRecord::Migration
  def change
    add_column :admin_admins, :last_login_at, :datetime
    add_column :admin_admins, :last_logout_at, :datetime
    add_column :admin_admins, :login_count, :integer, default: 0
    add_column :admin_admins, :last_login_ip, :string
  end
end
