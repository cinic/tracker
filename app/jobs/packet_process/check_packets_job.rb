module PacketProcess
  # Class DecodeJob.rb is
  # Find Packet on given packet id then
  # find Device on imei_substr and
  # save Sate with device_id
  class CheckPacketsJob < Struct.new(:device_id)
    def perform
      ref = Analytics::CheckPackets.new device_id
      ref.checked
    end

    def queue_name
      'packets'
    end
  end
end
