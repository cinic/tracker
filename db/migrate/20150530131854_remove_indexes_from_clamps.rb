# Remove indexes and create one double uniq index
class RemoveIndexesFromClamps < ActiveRecord::Migration
  def up
    dupl_clamps = []
    query = "SELECT * FROM (\
        SELECT id, time, device_id, ROW_NUMBER() OVER(PARTITION BY device_id, TIME ORDER BY id asc) AS ROW\
        FROM clamps\
      ) dups WHERE dups.row > 1"
    tmp_ary = ActiveRecord::Base.connection.execute(query).group_by{|i| i['device_id']}
    tmp_ary.each do |key,val|
      val.each do |i|
        clamps = Clamp.where(device_id: key.to_i, time: i['time'].to_datetime).pluck(:id).to_a
        clamps.shift
        dupl_clamps.concat(clamps)
      end
    end
    Clamp.find(dupl_clamps).map(&:delete)
    say 'Deleted duplicated clamps'
    execute <<-SQL
      DROP INDEX index_clamps_on_device_id;
      DROP INDEX index_clamps_on_time;
      DROP INDEX index_clamps_on_packet_id;
      CREATE UNIQUE INDEX index_clamps_on_device_id_time
        ON clamps (device_id, "time");
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX index_clamps_on_device_id_time;
      CREATE INDEX index_clamps_on_device_id ON clamps (device_id);
      CREATE INDEX index_clamps_on_time ON clamps ("time");
      CREATE INDEX index_clamps_on_packet_id ON clamps (packet_id);
    SQL
  end
end
