module Analytics
  # Save device states information from packet
  # find Packet on given packet id then
  # save Sate with device_id
  class ClampsDevice
    def initialize(packet_id)
      @packet = Packet.find(packet_id)
      @device_id = @packet.device_id
      @device = Device.find(@device_id)
    end

    def save
      return unless @packet.type == '85'
      return if clamps.nil? || clamps.empty?
      ActiveRecord::Base.connection.execute sql
    end

    private

    # Find last packet of the same type
    def last_packet
      Packet.where(
        'created_at < ? AND device_id = ? AND type = ?',
        @packet.created_at, @device_id, @packet.type
      ).last
    end

    # Select 81 type packets between 85
    def packets
      return [] if last_packet.nil?
      Packet.where('created_at < ? AND created_at > ? '\
                   'AND device_id = ? AND type = ?',
                   @packet.created_at, last_packet.created_at,
                   @device_id, '81'
                  )
    end

    # Set sql string for save clamps
    def clamps
      vals = []
      packets.each do |item|
        vals.concat(item.clamp_items)
      end
      vals.map { |i| "(#{@device_id}, '#{i}')" }
    end

    def sql
      'INSERT INTO clamps (device_id, time) '\
      'SELECT DISTINCT tmp_values.device_id, tmp_values.time::TIMESTAMP FROM '\
      "( VALUES #{clamps.join(',')} ) as tmp_values (device_id, time) "\
      'LEFT JOIN clamps tmp ON tmp.time = tmp_values.time::TIMESTAMP '\
      'AND tmp.device_id = tmp_values.device_id '\
      'WHERE tmp.time IS NULL'\
    end
  end
end
