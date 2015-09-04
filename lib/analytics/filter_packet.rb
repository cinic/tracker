module Analytics
  # Find Packet on given packet id then
  # find Device on imei_substr and
  # save packet with device_id
  class FilterPacket
    def initialize(packet_id)
      @packet = Packet.find(packet_id)
    end

    def checked
      @packet.update_attribute(:type, packet_type)
    end

    private

    def packet_type
      if @packet.content_bad?
        '820'
      elsif @packet.content_empty?
        '810'
      elsif @packet.content_old?
        '815'
      else
        @packet.type
      end
    end
  end
end
