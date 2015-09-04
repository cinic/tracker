module PacketProcess
  # Class DecodeJob.rb is
  # Find Packet on given packet id then
  # find Device on imei_substr and
  # save Sate with device_id
  class PingJob < Struct.new(:packet_id)
    def perform
      ping = Analytics::PingDevice.new packet_id
      ping.save
    end

    def queue_name
      'packets'
    end
  end
end
