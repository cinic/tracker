module PacketProcess
  # Class DecodeJob.rb is
  # Find Packet on given packet id then
  # find Device on imei_substr and
  # save Sate with device_id
  class StateJob < Struct.new(:packet_id)
    def perform
      state = Analytics::StateDevice.new packet_id
      state.save
    end

    def queue_name
      'packets'
    end
  end
end
