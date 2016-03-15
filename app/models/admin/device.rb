class Admin::Device < Device
  def check_packets
    Delayed::Job.enqueue(PacketProcess::CheckPacketsJob.new(id),
                         queue: 'packets', run_at: 1.minutes.from_now)
  end

  def refilter_packets
    Packet.where(device_id: id, type: %w(815 810 820))
      .update_all(type: '81')
    Delayed::Job.enqueue(PacketProcess::RefilterPacketsJob.new(id),
                         queue: 'packets', run_at: 1.minutes.from_now)
  end

  def refill_data
    pings_destroy
    states_destroy
    clamps_destroy
    Packet.where(device_id: id, type: %w(815 810 820))
      .update_all(type: '81')

    Delayed::Job.enqueue(PacketProcess::DataRefillJob.new(id, Time.now),
                         queue: 'packets', run_at: 1.minutes.from_now)
  end

  def refill_clamps
    clamps_destroy
    Delayed::Job.enqueue(PacketProcess::ClampsRefillJob.new(id),
                         queue: 'intervals', run_at: 1.minutes.from_now)
  end

  def refill_durations
    Clamp.where(device_id: id).update_all(duration: nil)
    Delayed::Job.enqueue(
      PacketProcess::DurationsJob.new(id, true),
      queue: 'intervals',
      run_at: 1.minutes.from_now
    )
  end

  def refill_types
    Delayed::Job.enqueue(
      PacketProcess::TypesCleanJob.new(id, true),
      queue: 'intervals',
      run_at: 1.minutes.from_now
    )
  end

  def refill_pings
    pings_destroy
    Packet.where(device_id: id, type: '85')
          .find_in_batches(batch_size: 1000) do |group|
      ActiveRecord::Base.transaction do
        group.each do |item|
          ping_job item.id
        end
      end
    end
  end

  def refill_states
    states_destroy
    Packet.where(device_id: id, type: '85')
      .find_in_batches(batch_size: 1000) do |group|
      ActiveRecord::Base.transaction do
        group.each do |item|
          state_job item.id
        end
      end
    end
  end

  def duplicated_clamps
    clamps_array = Clamp.where(device_id: id).order(time: :asc).pluck(:time).to_a
    clamps_array.group_by { |v| v }.select { |k, v| v.count > 1 }
  end

  def bad_clamps
    clamps_array = Clamp.where('device_id = ? AND duration <= ?', id, 0.0).to_a
  end

  private

  def clamps_destroy
    Clamp.where(device_id: id).delete_all
  end

  def states_destroy
    State.where(device_id: id).delete_all
  end

  def pings_destroy
    Ping.where(device_id: id).delete_all
  end

  def ping_job(packet_id)
    Delayed::Job.enqueue(
      PacketProcess::PingJob.new(packet_id),
      queue: 'packets',
      run_at: 1.minutes.from_now
    )
  end

  def state_job(packet_id)
    Delayed::Job.enqueue(
      PacketProcess::StateJob.new(packet_id),
      queue: 'packets',
      run_at: 1.minutes.from_now
    )
  end
end
