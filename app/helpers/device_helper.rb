module DeviceHelper
  def default_start_date
    DateTime.now.days_ago(5).in_time_zone(current_user.time_zone)
            .beginning_of_day.utc
  end

  def default_end_date
    DateTime.now.in_time_zone(current_user.time_zone)
            .end_of_day.utc
  end

  def default_query_now
    start_time = DateTime.now.strftime('%d-%m-%Y')
    { end_date: start_time, start_date: start_time }
  end

  def default_query_yesterday
    start_time = DateTime.now.days_ago(1).strftime('%d-%m-%Y')
    { end_date: start_time, start_date: start_time }
  end

  def default_query_week
    start_time = DateTime.now.days_ago(6).strftime('%d-%m-%Y')
    end_time = DateTime.now.strftime('%d-%m-%Y')
    { end_date: end_time, start_date: start_time }
  end

  def default_query_month
    start_time = DateTime.now.days_ago(29).strftime('%d-%m-%Y')
    end_time = DateTime.now.strftime('%d-%m-%Y')
    { end_date: end_time, start_date: start_time }
  end

  def default_query_year
    start_time = DateTime.now.days_ago(365).strftime('%d-%m-%Y')
    end_time = DateTime.now.strftime('%d-%m-%Y')
    { end_date: end_time, start_date: start_time }
  end

  def default_query_all_time
    device = current_user.devices.find(params[:id])
    packet = device.packets.first unless device.nil?
    start_time = if packet.nil?
                   current_user.created_at.strftime('%d-%m-%Y')
                 else
                   packet.created_at.strftime('%d-%m-%Y')
                 end
    end_time = DateTime.now.strftime('%d-%m-%Y')
    { end_date: end_time, start_date: start_time }
  end
end
