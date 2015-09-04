module Analytics
  # Save device states information from packet
  # find Packet on given packet id then
  # save Sate with device_id
  class DurationClamps
    # constant for limit batches
    STEP = 100

    def initialize(device_id)
      @device_id = device_id
      @clamp_1 = clamp_first
      @clamp_2 = clamp_last
    end

    # TODO (2016): if we have one clamp?
    # do something
    def save
      return if @clamp_1.nil?
      duration = @clamp_1.time.to_f - clamp_prev.time.to_f
      ActiveRecord::Base.connection.execute(sql)
      @clamp_1.update_attribute(:duration, duration)
    end

    private

    def clamp_prev
      Clamp.where('device_id = ? AND time < ?', @device_id, @clamp_1.time)
        .order(time: :asc).last || @clamp_1
    end

    def clamp_first
      Clamp.where(duration: nil, device_id: @device_id)
        .order(time: :asc).first
    end

    def clamp_last
      Clamp.where(duration: nil, device_id: @device_id)
        .order(time: :asc).last
    end

    def sql
      'WITH v_duration AS ( SELECT id, calc_duration FROM ('\
      'SELECT id, (extract(epoch from time) - extract(epoch from lag(time, 1) '\
      'over (ORDER BY time ASC))) as calc_duration FROM clamps '\
      "WHERE device_id=#{@device_id} AND time BETWEEN '#{@clamp_1.time}' "\
      "AND '#{@clamp_2.time}' ORDER BY time ASC) AS step) "\
      'UPDATE clamps SET duration = v_duration.calc_duration, '\
      'updated_at = NOW() FROM v_duration '\
      'WHERE clamps.id = v_duration.id;'
    end
  end
end
