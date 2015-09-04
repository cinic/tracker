module Analytics
  # Save device states information from packet
  # find Packet on given packet id then
  # save Sate with device_id
  class TypeClamps
    TEMP_TABLE_NAME = 't_clamps_type'
    def initialize(device_id)
      @device = Device.find(device_id)
    end

    def save
      Clamp.transaction do
        Clamp.where(type: nil, device_id: @device.id).where.not(duration: nil)
          .find_each(batch_size: 100) do |clamp|
          clamp.fill_type @device.check_type(clamp.duration.to_f)
        end
      end
    end

    def recreate
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute(temp_tbl)
        ActiveRecord::Base.connection.execute(temp_tbl_values)
        ActiveRecord::Base.connection.execute(update_clamps_types)
      end unless array_of_types.empty?
    end

    private

    def array_of_types
      contents = []
      Clamp.select(:id, :duration)
        .where(type: nil, device_id: @device.id).where.not(duration: nil)
        .find_in_batches(batch_size: 6000) do |group|
        group.each do |item|
          contents.push("(#{item.id}, '#{@device.check_type(item.duration.to_f)}')")
        end
      end
      contents.join(', ')
    end

    def temp_tbl
      "CREATE TEMP TABLE #{TEMP_TABLE_NAME} "\
      '(id INTEGER, type char(6), '\
      'updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()) '\
      'ON COMMIT DROP;'
    end

    def temp_tbl_values
      "INSERT INTO #{TEMP_TABLE_NAME} (id, type) VALUES #{array_of_types}"
    end

    def update_clamps_types
      "UPDATE clamps SET type = #{TEMP_TABLE_NAME}.type, "\
      "updated_at = #{TEMP_TABLE_NAME}.updated_at FROM #{TEMP_TABLE_NAME} "\
      "WHERE clamps.id = #{TEMP_TABLE_NAME}.id;"
    end
  end
end
