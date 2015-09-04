class AddDefaultsToClamps < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE clamps
        ALTER COLUMN created_at SET DEFAULT NOW(),
        ALTER COLUMN updated_at SET DEFAULT NOW();
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE clamps
        ALTER COLUMN created_at DROP DEFAULT,
        ALTER COLUMN updated_at DROP DEFAULT;
    SQL
  end
end
