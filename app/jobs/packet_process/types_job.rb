module PacketProcess
  # Class DeviceStatJob.rb is
  # decode and save data from pac
  class TypesJob < Struct.new(:device_id, :recreate)
    def perform
      ref = Analytics::TypeClamps.new device_id
      if recreate
        ref.recreate
      else
        ref.save
      end
    end

    def queue_name
      'intervals'
    end
  end
end
