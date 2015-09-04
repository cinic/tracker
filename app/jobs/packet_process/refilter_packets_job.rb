module PacketProcess
  class RefilterPacketsJob < Struct.new(:device_id)
    def perform
      ref = Analytics::RefilterPacket.new device_id
      ref.save
    end

    def queue_name
      'packets'
    end
  end
end
