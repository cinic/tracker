class ChangeClampDurationType < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE clamps
        ALTER COLUMN duration SET DEFAULT NULL,
        ALTER COLUMN duration TYPE decimal
        USING to_number(duration, '999999999.99');
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE clamps
        ALTER COLUMN duration DROP DEFAULT,
        ALTER COLUMN duration TYPE varchar(255);
    SQL
  end
end
