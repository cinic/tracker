module Analytics
  # Find Packet on given packet id then
  # find Device on imei_substr and
  # save packet with device_id
  class CheckPackets
    def initialize(device_id)
      @device = Device.find(device_id)
    end

    def checked
      return unless @device
      Packet.where(imei_substr: @device.imei_substr).update_all(device_id: @device.id)
    end
  end
end
