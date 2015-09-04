class RenameRawDataToPackets < ActiveRecord::Migration
  def change
    rename_table :raw_data, :packets
  end
end
