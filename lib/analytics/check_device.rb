module Analytics
  # Find Packet on given packet id then
  # find Device on imei_substr and
  # save packet with device_id
  class CheckDevice
    def initialize(packet_id)
      @packet = Packet.find(packet_id)
      @device = Device.where(imei_substr: @packet.imei_substr).first
    end

    def checked
      return unless @device
      @packet.device_id = @device.id
      @packet.decoded = true
      @packet.save
    end
  end
end
