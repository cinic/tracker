module PacketProcess
  # Class DecodeJob.rb is
  # Find Packet on given packet id then
  # find Device on imei_substr and
  # save Sate with device_id
  class FilterJob < Struct.new(:packet_id)
    def perform
      ref = Analytics::FilterPacket.new packet_id
      ref.checked
    end

    def success(job)
      check_device
    end

    def queue_name
      'packets'
    end

    private

    def check_device
      Delayed::Job.enqueue(
        PacketProcess::CheckJob.new(packet_id),
        queue: 'packets',
        run_at: 1.minutes.from_now
      )
    end
  end
end
