module Analytics
  # Save device states information from packet
  # find Packet on given packet id then
  # save Sate with device_id
  class DataRefill
    def initialize(device_id)
      @device = Device.find device_id
    end

    def save
      packets = Analytics::CheckPackets.new @device.id
      packets.checked

      Packet.where(device_id: @device.id).order(created_at: :asc)
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
