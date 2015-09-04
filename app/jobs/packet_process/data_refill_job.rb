module PacketProcess
  class DataRefillJob < Struct.new(:device_id, :time)
    def perform
      ref = Analytics::DataRefill.new device_id
      ref.save
    end

    def success(job)
      states_pings_create
      clamps_refill
    end

    def queue_name
      'packets'
    end

    private

    def clamps_refill
      Delayed::Job.enqueue(
        PacketProcess::ClampsRefillJob.new(device_id, true),
        queue: 'intervals',
        run_at: 3.minutes.from_now
      )
    end

    def states_pings_create
      Packet.where(device_id: device_id, type: '85')
        .find_in_batches(batch_size: 1000) do |group|
        ActiveRecord::Base.transaction do
          group.each do |item|
            Delayed::Job.enqueue(
              PacketProcess::PingJob.new(item.id),
              queue: 'packets',
              run_at: 1.minutes.from_now
            )
            Delayed::Job.enqueue(
              PacketProcess::StateJob.new(item.id),
              queue: 'packets',
              run_at: 1.minutes.from_now
            )
          end
        end
      end
    end
  end
end
