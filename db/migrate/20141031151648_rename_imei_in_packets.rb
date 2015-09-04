class RenameImeiInPackets < ActiveRecord::Migration
  def change
    rename_column :packets, :imei, :imei_substr
  end
end
