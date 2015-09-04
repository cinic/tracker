module PacketProcess
  # Class DecodeJob.rb is
  # Find Packet on given packet id then
  # find Device on imei_substr and
  # save Sate with device_id
  class CheckJob < Struct.new(:packet_id)
    def perform
      ref = Analytics::CheckDevice.new packet_id
      ref.checked
    end

    def success(job)
      return unless packet_type == '85'
      ping_device
      state_device
      clamps_device
    end

    def queue_name
      'packets'
    end

    private

    def ping_device
      Delayed::Job.enqueue(
        PacketProcess::PingJob.new(packet_id),
        queue: 'packets',
        run_at: 1.minutes.from_now
      )
    end

    def state_device
      Delayed::Job.enqueue(
        PacketProcess::StateJob.new(packet_id),
        queue: 'packets',
        run_at: 1.minutes.from_now
      )
    end

    def clamps_device
      Delayed::Job.enqueue(
        PacketProcess::ClampsJob.new(packet_id),
        queue: 'intervals',
        run_at: 1.minutes.from_now
      )
    end

    def packet_type
      Packet.find(packet_id).type
    end
  end
end
