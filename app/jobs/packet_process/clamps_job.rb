module PacketProcess
  # Class DeviceStatJob.rb is
  # decode and save data from pac
  class ClampsJob < Struct.new(:packet_id)
    def perform
      ref = Analytics::ClampsDevice.new packet_id
      ref.save
    end

    def success(job)
      check_durations
    end

    def queue_name
      'intervals'
    end

    private

    def check_durations
      device_id = Packet.find(packet_id).device_id
      Delayed::Job.enqueue(
        PacketProcess::DurationsJob.new(device_id),
        queue: 'intervals',
        run_at: 1.minutes.from_now
      )
    end
  end
end
