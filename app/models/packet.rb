# Class named Packet.rb
# reserved chars: content[88..103].to_i(16)
class Packet < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessor :imei

  belongs_to :device

  scope :not_decoded, -> { where(decoded: false) }
  scope :decoded, -> { where(decoded: true) }

  before_create :prepare_imei
  before_create :prepare_sim_balance

  def self.empty
    sought = []
    packets = where(type: '81')
    packets.each do |item|
      next unless item.content.scan(/.{12,16}/).map { |z| z if z.to_i > 0 }
                  .delete_if(&:nil?).empty?

      sought << item.id
    end
    find(sought)
  end

  def self.remove_empty
    where(type: '81').each do |i|
      i.update_attribute(:type, '810') if i.clamp_items.empty?
    end
  end

  def self.remove_duplicates
    grouped = where(type: '81').group_by { |i| [i.device_id, i.content[0..16]] }
    grouped.values.each do |duplicates|
      first_one = duplicates.shift
      duplicates.each do |double|
        double.update_attribute(:type, '815') unless double.nil?
      end
    end
  end

  def content_old?
    return false if clamp_items.empty? || type == '85'
    clamp_items.first > clamp_items.last
  end

  def content_empty?
    return false if type == '85'
    clamp_items.empty?
  end

  def content_bad?
    return false unless type == '81'
    content.match(/[a-eg-zA-EG-Z]/) ? true : false
  end

  def date
    return if content[22..27].nil? || type == '81'
    content[22..27].to_i(16)
  end

  def time
    return if content[28..33].nil? || type == '81'
    content[28..33].to_i(16)
  end

  def v_batt
    return if content[34..37].nil? || type == '81'
    content[34..37].to_i(16).to_s.gsub!(/^(.)/, '\\0.').to_f
  end

  def v_batt_raw
    return if content[34..37].nil? || type == '81'
    content[34..37]
  end

  def temp
    return if content[38..39].nil? || type == '81'
    content[38..39].to_i(16) - 100
  end

  def temp_raw
    return if content[38..39].nil? || type == '81'
    content[38..39] + '00'
  end

  def switch_on_init
    return if content[40..41].nil? || type == '81'
    content[40..41].to_i(16)
  end

  def data_type
    return if content[42..43].nil? || type == '81'
    content[42..43].to_i(16)
  end

  def switch_on_num
    return if content[44..47].nil? || type == '81'
    content[44..47].to_i(16)
  end

  def fw_ver
    return if content[48..49].nil? || type == '81'
    content[48..49].to_i(16)
  end

  def item_errors
    return if content[50..51].nil? || type == '81'
    content[50..51].to_i(16)
  end

  def satellite
    return if content[52..53].nil? || type == '81'
    content[52..53].to_i(16)
  end

  def hdo
    return if content[54..55].nil? || type == '81'
    content[54..55].to_i(16)
  end

  def log
    return if content[56..87].nil? || type == '81'
    content[56..87].to_i(16)
  end

  def rssi
    return if content[104..105].nil? || type == '81'
    content[104..105].to_i(10)
  end

  def bss
    return if content[106..107].nil? || type == '81'
    content[106..107].to_i(16)
  end

  def bss_raw
    return if content[106..107].nil? || type == '81'
    content[106..107]
  end

  def gsm_data
    return if content[106..107].nil? || type == '81'
    start = 107
    Array.new(content[106..107].to_i(16)) do |i|
      unless content[(start += 1)..(start += 3)].nil?
        mcc = content[(start - 3)..start].to_i(10)
      end
      unless content[(start += 1)..(start += 1)].nil?
        mnc = content[(start - 1)..start].to_i(10)
      end
      unless content[(start += 1)..(start += 5)].nil?
        lac = content[(start - 5)..start]
      end
      unless content[(start += 1)..(start += 5)].nil?
        cell_id = content[(start - 5)..start]
      end
      unless content[(start += 1)..(start += 1)].nil?
        pwr = content[(start - 1)..start].to_i(16)
      end
      unless content[(start += 1)..(start += 1)].nil?
        ta = content[(start - 1)..start].to_i(16)
      end if i == 0
      { mcc: mcc, mnc: mnc, lac: lac, cell_id: cell_id, pwr: pwr, ta: ta }
    end
  end

  def gsm_data_raw
    content[108..(110 + bss * 20)]
  end

  def clamp_items
    return [] if type == '85'
    cla = []
    content.scan(/.{12,16}/).map { |z| z if z.to_i > 0 }.delete_if(&:nil?)
      .each do |z|
        next unless clamp_norm?(z)
        cla << Time.zone.local(
                ('20' + z[10..11]).to_i,  z[8..9].to_i, z[6..7].to_i,
                z[0..1].to_i, z[2..3].to_i, z[4..5].to_i
              )
      end
    cla
  end

  def days_in_packet
    return if clamp_items.empty?
    clamp_items.map(&:yday).uniq.size
  end

  def dates_in_packet
    return if clamp_items.empty?
    clamp_items.map(&:to_date).uniq
  end

  def gis_coords
    return unless type == '85'
    coords = Gis::Converter.new(gis_packet)
    coords.to_dec
  end

  private

  def prepare_imei
    self.imei_substr = imei
  end

  def prepare_sim_balance
    self.sim_balance = sim_balance.nil? ? nil : sim_balance.gsub(',', '.')
  end

  def gis_packet
    length = (
      "#{APP_CONFIG['zanoza_gis_serial']}#{bss_raw}#{gsm_data_raw}"\
      "#{v_batt_raw}#{temp_raw}#{APP_CONFIG['zanoza_gis_end']}".length / 2
    ).to_s(16)
    length = (length.length < 3) ? "00#{length}" : "0#{length}"
    "#{APP_CONFIG['zanoza_gis_sign']}#{length}"\
    "#{APP_CONFIG['zanoza_gis_serial']}#{bss_raw}"\
    "#{gsm_data_raw}#{v_batt_raw}#{temp_raw}#{APP_CONFIG['zanoza_gis_end']}"
  end

  def clamp_norm?(z, date = false, time = false)
    if z[10..11].to_i.between?((created_at.strftime('%y').to_i - 1), created_at.strftime('%y').to_i) &&
       (z[8..9].to_i.between?(1, 12) && z[8..9].to_i <= created_at.strftime('%m').to_i) &&
       (z[6..7].to_i.between?(1, 31) && !z[6..7].match(/[a-zA-Z]/))
      date = true
    end
    if (z[0..1].to_i.between?(0, 23) && !z[0..1].match(/[a-zA-Z]/)) &&
       (z[2..3].to_i.between?(0, 59) && !z[2..3].match(/[a-zA-Z]/)) &&
       (z[4..5].to_i.between?(0, 59) && !z[4..5].match(/[a-zA-Z]/))
      time = true
    end
    time && date
  end
end
