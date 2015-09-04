module Paginate
  extend ActiveSupport::Concern

  private

  def data_for_pagination(options = {})
    if modes_type
      klass = Object.const_get Packet::MODES[modes_type.to_i]
    else
      klass = options[:klass].nil? ? (Object.const_get controller_path.classify) : (Object.const_get options[:klass])
    end
    date_col = options[:date_col].nil? ? :created_at : options[:date_col]
    klass = klass.where(
      date_col => start_date.to_datetime..end_date.to_datetime
    ) if !start_date.nil? && !end_date.nil?
    klass = klass.where(type: packet_type) if packet_type
    klass = klass.where(device_id: filter_id) unless filter_id.nil?
    klass = klass.where(imei_substr: filter_imei) unless filter_imei.nil?
    klass.page(page).per(per_page)
  end

  def page
    params[:page]
  end

  def per_page
    params[:per_page]
  end

  def filter_id
    if params[:device_id].nil? || params[:device_id] == ''
      nil
    else
      params[:device_id]
    end
  end

  def filter_imei
    if params[:imei].nil? || params[:imei] == ''
      nil
    else
      params[:imei]
    end
  end

  def start_date
    if params[:start_date].nil? || params[:start_date] == ''
      nil
    else
      params[:start_date]
    end
  end

  def end_date
    if params[:end_date].nil? || params[:end_date] == ''
      nil
    else
      params[:end_date]
    end
  end

  def packet_type
    return if params[:packet_type].nil? || params[:packet_type] == ''
    params[:packet_type]
  end

  def modes_type
    return if params[:modes_type].nil? || params[:modes_type] == ''
    params[:modes_type]
  end
end
