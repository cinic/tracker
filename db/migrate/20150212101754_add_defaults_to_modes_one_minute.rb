class AddDefaultsToModesOneMinute < ActiveRecord::Migration
  def change
    change_column :modes_one_minutes, :norm, :integer, default: 0
    change_column :modes_one_minutes, :idle, :integer, default: 0
    change_column :modes_one_minutes, :acl, :integer, default: 0
    change_column :modes_one_minutes, :fail, :integer, default: 0
    change_column :modes_one_minutes, :duration_idle, :float, default: 0.0
    change_column :modes_one_minutes, :duration_norm, :float, default: 0.0
    change_column :modes_one_minutes, :duration_acl, :float, default: 0.0
    change_column :modes_one_minutes, :duration_fail, :float, default: 0.0

    change_column :modes_five_minutes, :norm, :integer, default: 0
    change_column :modes_five_minutes, :idle, :integer, default: 0
    change_column :modes_five_minutes, :acl, :integer, default: 0
    change_column :modes_five_minutes, :fail, :integer, default: 0
    change_column :modes_five_minutes, :duration_idle, :float, default: 0.0
    change_column :modes_five_minutes, :duration_norm, :float, default: 0.0
    change_column :modes_five_minutes, :duration_acl, :float, default: 0.0
    change_column :modes_five_minutes, :duration_fail, :float, default: 0.0

    change_column :modes_thirty_minutes, :norm, :integer, default: 0
    change_column :modes_thirty_minutes, :idle, :integer, default: 0
    change_column :modes_thirty_minutes, :acl, :integer, default: 0
    change_column :modes_thirty_minutes, :fail, :integer, default: 0
    change_column :modes_thirty_minutes, :duration_idle, :float, default: 0.0
    change_column :modes_thirty_minutes, :duration_norm, :float, default: 0.0
    change_column :modes_thirty_minutes, :duration_acl, :float, default: 0.0
    change_column :modes_thirty_minutes, :duration_fail, :float, default: 0.0

    change_column :modes_one_hours, :norm, :integer, default: 0
    change_column :modes_one_hours, :idle, :integer, default: 0
    change_column :modes_one_hours, :acl, :integer, default: 0
    change_column :modes_one_hours, :fail, :integer, default: 0
    change_column :modes_one_hours, :duration_idle, :float, default: 0.0
    change_column :modes_one_hours, :duration_norm, :float, default: 0.0
    change_column :modes_one_hours, :duration_acl, :float, default: 0.0
    change_column :modes_one_hours, :duration_fail, :float, default: 0.0

    change_column :modes_four_hours, :norm, :integer, default: 0
    change_column :modes_four_hours, :idle, :integer, default: 0
    change_column :modes_four_hours, :acl, :integer, default: 0
    change_column :modes_four_hours, :fail, :integer, default: 0
    change_column :modes_four_hours, :duration_idle, :float, default: 0.0
    change_column :modes_four_hours, :duration_norm, :float, default: 0.0
    change_column :modes_four_hours, :duration_acl, :float, default: 0.0
    change_column :modes_four_hours, :duration_fail, :float, default: 0.0

    change_column :modes_one_days, :norm, :integer, default: 0
    change_column :modes_one_days, :idle, :integer, default: 0
    change_column :modes_one_days, :acl, :integer, default: 0
    change_column :modes_one_days, :fail, :integer, default: 0
    change_column :modes_one_days, :duration_idle, :float, default: 0.0
    change_column :modes_one_days, :duration_norm, :float, default: 0.0
    change_column :modes_one_days, :duration_acl, :float, default: 0.0
    change_column :modes_one_days, :duration_fail, :float, default: 0.0
  end
end
