class FixColumnTypesInPackets < ActiveRecord::Migration
  def up
    change_column :packets, :imei_substr, :string, null: false
    remove_column :packets, :updated_at, :datetime
    remove_column :packets, :datetime, :datetime
    execute <<-SQL
      ALTER TABLE packets
        DROP CONSTRAINT raw_data_pkey
    SQL
    execute <<-SQL
      ALTER TABLE packets
        ADD PRIMARY KEY (id)
    SQL
  end

  def down
    change_column :packets, :imei_substr, :decimal, precision: 15, scale: 0, null: false
    add_column    :packets, :updated_at, :datetime
    add_column    :packets, :datetime, :datetime
  end
end
