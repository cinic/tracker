module PacketProcess
  # Class DeviceStatJob.rb is
  # decode and save data from pac
  class DurationsJob < Struct.new(:device_id, :recreate)
    def perform
      ref = Analytics::DurationClamps.new device_id
      ref.save
    end

    def success(job)
      check_types
    end

    def queue_name
      'intervals'
    end

    private

    def check_types
      Delayed::Job.enqueue(
        PacketProcess::TypesJob.new(device_id, recreate),
        queue: 'intervals',
        run_at: 1.minutes.from_now
      )
    end
  end
end
