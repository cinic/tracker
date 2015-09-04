module Analytics
  # Re-filter each 81th packets
  # on device
  class RefilterPacket
    def initialize(device_id)
      @device = Device.find device_id
    end

    def save
      check_device
      filter_packets
    end

    private

    def check_device
      packets = Analytics::CheckPackets.new @device.id
      packets.checked
    end

    def filter_packets
      Packet.where(device_id: @device.id, type: '81').order(created_at: :asc)
        .find_in_batches(batch_size: 1000) do |items|
        ActiveRecord::Base.transaction do
          items.each do |item|
            packet = Analytics::FilterPacket.new item.id
            packet.checked
          end
        end
      end
    end
  end
end
