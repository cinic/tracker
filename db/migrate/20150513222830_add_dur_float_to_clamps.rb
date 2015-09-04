class AddDurFloatToClamps < ActiveRecord::Migration
  def change
    add_column :clamps, :dur_float, :float, default: 0, :precision => 6, :scale => 2
  end
end
