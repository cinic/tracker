module Analytics
  # Save device states information from packet
  # find Packet on given packet id then
  # save Sate with device_id
  class PingDevice
    def initialize(packet_id)
      @packet = Packet.find packet_id
      @device = Device.find @packet.device_id
    end

    def save
      return unless @packet.type == '85'
      ping = Ping.new
      ping.ping_was = @packet.created_at
      ping.ping_will = ping_time
      ping.device_id = @packet.device_id
      ping.save!
    end

    private

    # time saved in seconds
    def ping_time
      Time.zone.at(@packet.created_at.to_i + @device.interval_in_seconds.to_i)
    end
  end
end
