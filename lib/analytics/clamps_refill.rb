module Analytics
  # Save device states information from packet
  # find Packet on given packet id then
  # save Sate with device_id
  class ClampsRefill
    def initialize(device_id)
      @device_id = device_id
      @contents = []
    end

    def save
      Packet.where(device_id: @device_id, type: '81')
        .find_in_batches(batch_size: 100) do |items|
        items.each do |item|
          item.clamp_items.map { |i| @contents.push("(#{@device_id}, '#{i}')") }
        end
        ActiveRecord::Base.connection.execute sql
        @contents.clear
      end
    end

    private

    def sql
      'INSERT INTO clamps (device_id, time) '\
      'SELECT DISTINCT tmp_values.device_id, tmp_values.time::TIMESTAMP FROM '\
      "( VALUES #{@contents.join(',')} ) as tmp_values (device_id, time) "\
      'LEFT JOIN clamps tmp ON tmp.time = tmp_values.time::TIMESTAMP '\
      'WHERE tmp.time IS NULL'\
    end
  end
end
