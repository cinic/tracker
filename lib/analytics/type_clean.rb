module Analytics
  # Save device states information from packet
  # find Packet on given packet id then
  # save Sate with device_id
  class TypeClean
    def initialize(device_id)
      @device = Device.find(device_id)
    end

    def save
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute(update_clamps_types)
      end
    end

    private

    def update_clamps_types
      'UPDATE clamps SET type = NULL, '\
      'updated_at = NOW() '\
      "WHERE clamps.device_id = #{@device.id};"
    end
  end
end
