module Analytics
  # Save device states information from packet
  # find Packet on given packet id then
  # save Sate with device_id
  class StateDevice
    def initialize(packet_id)
      @packet = Packet.find(packet_id)
    end

    def save
      return unless @packet.type == '85'
      state = State.new
      state.sim_balance = @packet.sim_balance
      state.temp = @packet.temp
      state.v_batt = @packet.v_batt
      state.gis = @packet.gis_coords
      state.datetime = @packet.created_at
      state.rssi = @packet.rssi
      state.device_id = @packet.device_id
      state.save!
    end
  end
end
