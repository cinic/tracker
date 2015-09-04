class AddDecodedToRawData < ActiveRecord::Migration
  def change
    add_column :raw_data, :decoded, :boolean, default: false
  end
end
