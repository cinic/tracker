class AddTypeAndVersionToRawData < ActiveRecord::Migration
  def change
    add_column :raw_data, :type, :string
    add_column :raw_data, :version, :string
  end
end
