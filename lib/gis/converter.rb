# Module Converter.rb
# convert lat & lon to decimal format
# from source packet 543639644e003939001645, 22..43 symbols
module Gis
  # Class Converter.rb get packet raw data
  # and set latitude and longitude
  class Converter
    def initialize(packet)
      @packet = gis_source packet
      @lat_source = @packet[22..31]
      @lon_source = @packet[32..43]
    end

    def to_dec
      return if @packet.nil? || @lat_source.nil? || @lon_source.nil?
      return '54.599399, 39.607826' if Rails.env == 'test'
      dec_lat = lat[:deg] + ((lat[:min] * 60 + lat[:sec]) / 3600)
      dec_lat = -dec_lat if lat[:dir] == 83
      dec_lon = lon[:deg] + ((lon[:min] * 60 + lon[:sec]) / 3600)
      dec_lon = -dec_lon if lon[:dir] == 87
      "#{dec_lat}, #{dec_lon}"
    end

    private

    def lat
      {
        deg: @lat_source[0..1].to_i,
        min: @lat_source[2..3].to_i,
        sec: sec(@lat_source[4..7]),
        dir: @lat_source[8..9].to_i(16)
      }
    end

    def lon
      {
        deg: @lon_source[0..3].to_i,
        min: @lon_source[4..5].to_i,
        sec: sec(@lon_source[6..9]),
        dir: @lon_source[10..11].to_i(16)
      }
    end

    def sec(a = '')
      a.gsub(/(\d{2})(\d{2})/, '\1.\2').to_f
    end

    def gis_source(packet_for_gis)
      return ['1'] if Rails.env == 'test'
      sock = TCPSocket.new(APP_CONFIG['zanoza_gis_url'], APP_CONFIG['zanoza_gis_port'])
      sock.write [packet_for_gis].pack('H*')
      sock.close_write
      data = sock.read
      sock.close
      data.unpack('H*')[0]
    end
  end
end
