module PacketProcess
  # Class DeviceStatJob.rb is
  # decode and save data from pac
  class ClampsRefillJob < Struct.new(:device_id, :recreate)
    def perform
      ref = Analytics::ClampsRefill.new device_id
      ref.save
    end

    def success(job)
      check_durations if recreate
    end

    def queue_name
      'intervals'
    end

    private

    def check_durations
      Delayed::Job.enqueue(
        PacketProcess::DurationsJob.new(device_id, true),
        queue: 'intervals',
        run_at: 1.minutes.from_now
      )
    end
  end
end
