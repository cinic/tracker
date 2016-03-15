module API
  module V1
    class Device
      MODES_COLORS = { acl: '#a1d1f3', fail: '#f87e72', idle: '#eeb679',
                       norm: '#a4dc85', total: '#d9a0ea',
                       acl_fail_norm: '#9c6876', goal: '#ead581' }.freeze

      MODES_CYCLE_TYPES = ::Device::CYCLE_TYPES

      def initialize(id, time_start = nil, time_end = nil,
                     zone = 'Europe/Moscow')
        @device = ::Device.select(:id, :normal_cycle, :slot_number,
                                  :material_consumption).where(id: id).first
        @user_time_zone = ActiveSupport::TimeZone.find_tzinfo(zone).identifier
        @time_start = start_date(time_start)
        @time_end = end_date(time_end)
      end

      def summary_table
        unless ts_start.nil?
          data = Clamp.find_by_sql [sql_table, summary_table_params]
        end
        if data.nil? || data.empty?
          data = [I18n.translate('api.device.no_data')]
        end
        data
      end

      private

      def sql_table
        'WITH w AS ('\
          'WITH RECURSIVE t(segment) AS (VALUES (FLOOR(:time_start_i / 86400)) '\
          	'UNION ALL SELECT segment + 1 FROM t WHERE segment < FLOOR(:time_end_i / 86400)) '\
          'SELECT '\
            '(t1.segment * 86400)::VARCHAR(256) AS segment, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.duration_norm END AS durations_norm, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.duration_acl END AS durations_acl, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.duration_fail END AS durations_fail, '\
            'CASE WHEN t2.segment IS NULL THEN 86400 ELSE t2.duration_idle END AS durations_idle, '\
            'ROUND((CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.duration_norm / (t2.duration_norm + t2.duration_acl + '\
              't2.duration_fail + t2.duration_idle) * 100 END)::NUMERIC,4) AS durations_norm_percent, '\
            'ROUND((CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.duration_acl / (t2.duration_norm + t2.duration_acl + '\
              't2.duration_fail + t2.duration_idle) * 100 END)::NUMERIC,4) AS durations_acl_percent, '\
            'ROUND((CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.duration_fail / (t2.duration_norm + t2.duration_acl + '\
              't2.duration_fail + t2.duration_idle) * 100 END)::NUMERIC,4) AS durations_fail_percent, '\
            'ROUND((CASE WHEN t2.segment IS NULL THEN 100.0 ELSE t2.duration_idle / (t2.duration_norm + t2.duration_acl + '\
              't2.duration_fail + t2.duration_idle) * 100 END)::NUMERIC,4) AS durations_idle_percent, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.clamps_cnt_norm END AS clamps_norm, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.clamps_cnt_acl END AS clamps_acl, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.clamps_cnt_fail END AS clamps_fail, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.clamps_cnt_idle END AS clamps_idle, '\
            'ROUND(CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.clamps_cnt_norm::NUMERIC / (t2.clamps_cnt_norm + t2.clamps_cnt_acl + '\
              't2.clamps_cnt_fail + t2.clamps_cnt_idle) * 100 END,4) AS clamps_norm_percent, '\
            'ROUND(CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.clamps_cnt_acl::NUMERIC / (t2.clamps_cnt_norm + t2.clamps_cnt_acl + '\
              't2.clamps_cnt_fail + t2.clamps_cnt_idle) * 100 END,4) AS clamps_acl_percent, '\
            'ROUND(CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.clamps_cnt_fail::NUMERIC / (t2.clamps_cnt_norm + t2.clamps_cnt_acl + '\
              't2.clamps_cnt_fail + t2.clamps_cnt_idle) * 100 END,4) AS clamps_fail_percent, '\
            'ROUND(CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.clamps_cnt_idle::NUMERIC / (t2.clamps_cnt_norm + t2.clamps_cnt_acl + '\
              't2.clamps_cnt_fail + t2.clamps_cnt_idle) * 100 END,4) AS clamps_idle_percent, '\
            'CASE WHEN t2.segment IS NULL THEN 86400 ELSE (t2.duration_norm + t2.duration_acl + '\
              't2.duration_fail + t2.duration_idle) END AS durations, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE (t2.clamps_cnt_norm + t2.clamps_cnt_acl + '\
              't2.clamps_cnt_fail + t2.clamps_cnt_idle) END AS clamps, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE (t2.clamps_cnt_norm + t2.clamps_cnt_acl + '\
              't2.clamps_cnt_fail + t2.clamps_cnt_idle) * :slot_number END AS perfomance_total_items, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE (t2.clamps_cnt_norm + t2.clamps_cnt_acl + '\
              't2.clamps_cnt_fail + t2.clamps_cnt_idle) END AS perfomance_total_clamps, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.duration_fail / :normal_cycle * :slot_number '\
              'END AS perfomance_fail_items, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE t2.duration_fail / :normal_cycle '\
              'END AS perfomance_fail_clamps, '\
            'CASE WHEN t2.segment IS NULL THEN (86400 / :normal_cycle * :slot_number) '\
              'ELSE (t2.duration_idle / :normal_cycle * :slot_number) '\
              'END AS perfomance_idle_items, '\
            'CASE WHEN t2.segment IS NULL THEN (86400 / :normal_cycle) '\
              'ELSE t2.duration_idle / :normal_cycle '\
              'END AS perfomance_idle_clamps, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE COALESCE(ROUND(t2.duration_norm::NUMERIC / NULLIF(t2.clamps_cnt_norm,0)::NUMERIC,4),0) '\
    	         'END AS times_norm, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE COALESCE(ROUND((t2.duration_norm + t2.duration_acl + t2.duration_fail)::NUMERIC / NULLIF((t2.clamps_cnt_norm + t2.clamps_cnt_acl + t2.clamps_cnt_fail),0)::NUMERIC,4), 0) '\
               'END AS times_all, '\
            ':normal_cycle AS times_goal, '\
            'CASE WHEN t2.segment IS NULL THEN 0 ELSE (t2.clamps_cnt_norm + t2.clamps_cnt_acl + t2.clamps_cnt_fail + t2.clamps_cnt_idle) * :material_consumption / 1000.0 END AS material_consumption '\
          'FROM t t1 LEFT JOIN ('\
            'SELECT segment, calc_duration_sum_norm, calc_duration_sum_acl, calc_duration_sum_fail, '\
              'calc_duration_sum_idle, '\
              'CASE WHEN (lead(diff_duration_sum_norm, 1) OVER ())::NUMERIC >  0 '\
                'THEN calc_duration_sum_norm + ((lead(diff_duration_sum_norm, 1) OVER ())::NUMERIC % 86400) '\
              	'ELSE calc_duration_sum_norm END AS duration_norm, '\
              'CASE WHEN (lead(diff_duration_sum_acl, 1) OVER ())::NUMERIC >  0 '\
                'THEN calc_duration_sum_acl + ((lead(diff_duration_sum_acl, 1) OVER ())::NUMERIC % 86400) '\
                'ELSE calc_duration_sum_acl END AS duration_acl, '\
              'CASE WHEN (lead(diff_duration_sum_fail, 1) OVER ())::NUMERIC >  0 '\
                'THEN calc_duration_sum_fail + ((lead(diff_duration_sum_fail, 1) OVER ())::NUMERIC % 86400) '\
                'ELSE calc_duration_sum_fail END AS duration_fail, '\
              'CASE WHEN (lead(diff_duration_sum_idle, 1) OVER ())::NUMERIC >  0 '\
                'THEN calc_duration_sum_idle + ((lead(diff_duration_sum_idle, 1) OVER ())::NUMERIC % 86400) '\
              	'ELSE calc_duration_sum_idle END AS duration_idle, '\
              'clamps_cnt_norm, clamps_cnt_acl, clamps_cnt_fail, clamps_cnt_idle '\
            'FROM ('\
              'SELECT '\
                'segment, '\
            		"SUM(CASE WHEN type = 'norm' THEN calc_duration ELSE 0 END) AS calc_duration_sum_norm, "\
            		"SUM(CASE WHEN type = 'acl' THEN calc_duration ELSE 0 END) AS calc_duration_sum_acl, "\
            		"SUM(CASE WHEN type = 'fail' THEN calc_duration ELSE 0 END) AS calc_duration_sum_fail, "\
            		"SUM(CASE WHEN type = 'idle' THEN calc_duration ELSE 0 END) AS calc_duration_sum_idle, "\
            		"SUM(CASE WHEN type = 'norm' THEN duration-calc_duration ELSE 0 END) AS diff_duration_sum_norm, "\
            		"SUM(CASE WHEN type = 'acl' THEN duration-calc_duration ELSE 0 END) AS diff_duration_sum_acl, "\
            		"SUM(CASE WHEN type = 'fail' THEN duration-calc_duration ELSE 0 END) AS diff_duration_sum_fail, "\
            		"SUM(CASE WHEN type = 'idle' THEN duration-calc_duration ELSE 0 END) AS diff_duration_sum_idle, "\
            		"count(CASE WHEN type='norm' THEN 1 ELSE NULL END) AS clamps_cnt_norm, "\
            		"count(CASE WHEN type='acl' THEN 1 ELSE NULL END) AS clamps_cnt_acl, "\
            		"count(CASE WHEN type='fail' THEN 1 ELSE NULL END) AS clamps_cnt_fail, "\
            		"count(CASE WHEN type='idle' THEN 1 ELSE NULL END) AS clamps_cnt_idle "\
            	'FROM ('\
                'SELECT id, type, time, duration, '\
            		  'CASE WHEN (duration > (ts - (FLOOR(ts / 86400) * 86400)) ) '\
                    'THEN ts - (FLOOR(ts / 86400) * 86400) ELSE duration END AS calc_duration, '\
            			'ts, FLOOR(ts / 86400) AS segment, '\
            			'(FLOOR(ts / 86400) * 86400) AS segment_start_ts, '\
            			'((FLOOR(ts / 86400)+1) * 86400) AS segment_end_ts '\
            		'FROM ('\
                  'SELECT id, type, time, duration::FLOAT, '\
                    "extract(epoch from time AT TIME ZONE 'UTC' AT TIME ZONE :time_zone) AS ts "\
            			'FROM clamps '\
            			"WHERE device_id = :device_id AND time BETWEEN :time_start AND :time_end ORDER BY time ASC "\
                ') AS step1'\
            	') AS step2 GROUP BY segment ORDER BY segment ASC'\
            ') AS step3'\
          ') t2 ON t2.segment = t1.segment ORDER BY t1.segment DESC) '\
        'SELECT to_timestamp(segment::int)::date::varchar(256) as segment, '\
          'durations_norm, durations_acl, durations_fail, durations_idle, '\
          'durations_norm_percent, durations_acl_percent, durations_fail_percent, durations_idle_percent, '\
          'clamps_norm, clamps_acl, clamps_fail, clamps_idle, '\
          'clamps_norm_percent, clamps_acl_percent, clamps_fail_percent, clamps_idle_percent, durations, clamps, '\
          'perfomance_total_items, perfomance_total_clamps, perfomance_fail_items, '\
          'perfomance_fail_clamps, perfomance_idle_items, perfomance_idle_clamps, '\
          'times_norm, times_all, times_goal, material_consumption '\
        'FROM w UNION ALL SELECT :total_sum, SUM(durations_norm), SUM(durations_acl), '\
          'SUM(durations_fail), SUM(durations_idle), '\
          'ROUND(AVG(durations_norm_percent::NUMERIC), 4), '\
          'ROUND(AVG(durations_acl_percent::NUMERIC), 4), '\
          'ROUND(AVG(durations_fail_percent::NUMERIC), 4), '\
          'ROUND(AVG(durations_idle_percent::NUMERIC), 4), '\
          'SUM(clamps_norm), SUM(clamps_acl), SUM(clamps_fail), SUM(clamps_idle), '\
          'COALESCE(ROUND(AVG(CASE WHEN clamps_norm_percent > 0 THEN clamps_norm_percent::NUMERIC END),4), 0), '\
          'COALESCE(ROUND(AVG(CASE WHEN clamps_acl_percent > 0 THEN clamps_acl_percent::NUMERIC END),4), 0), '\
          'COALESCE(ROUND(AVG(CASE WHEN clamps_fail_percent > 0 THEN clamps_fail_percent::NUMERIC END),4), 0), '\
          'COALESCE(ROUND(AVG(CASE WHEN clamps_idle_percent > 0 THEN clamps_idle_percent::NUMERIC END),4), 0), '\
          'SUM(durations), SUM(clamps), SUM(ROUND(perfomance_total_items::NUMERIC,4)), '\
          'SUM(ROUND(perfomance_total_clamps::NUMERIC,4)), SUM(ROUND(perfomance_fail_items::NUMERIC,4)), '\
          'SUM(ROUND(perfomance_fail_clamps::NUMERIC,4)), '\
          'SUM(ROUND(perfomance_idle_items::NUMERIC,4)), SUM(ROUND(perfomance_idle_clamps::NUMERIC,4)), '\
          'COALESCE(ROUND(AVG(CASE WHEN times_norm > 0 THEN times_norm END), 2), 0), '\
          'COALESCE(ROUND(AVG(CASE WHEN times_all > 0 THEN times_all END), 2), 0), '\
          'ROUND(AVG(CASE WHEN times_goal > 0 THEN times_goal END), 2), SUM(material_consumption) '\
        'FROM w ORDER BY segment DESC'
      end

      def summary_table_params
        segment_start = ts_start.nil? ? nil : ts_start.to_i + ts_start.in_time_zone(@user_time_zone).utc_offset
        segment_end = ts_end.nil? ? nil : ts_end.to_i + ts_end.in_time_zone(@user_time_zone).utc_offset
        total_sum = I18n.translate('api.device.summary_table.total')
        params = { device_id: @device.id, time_start: ts_start, time_end: ts_end,
          time_start_i: segment_start, time_end_i: segment_end, total_sum: total_sum,
          normal_cycle: normal_cycle, slot_number: slot_number, material_consumption: material_consumption,
          time_zone: @user_time_zone, rnd: 4 }
      end

      def id
        @device[:id]
      end

      def normal_cycle
        @device[:normal_cycle].to_f
      end

      def slot_number
        @device[:slot_number].to_f
      end

      def material_consumption
        @device[:material_consumption].to_f
      end

      def start_date(date)
        if date.nil? || date.empty?
          DateTime.now.days_ago(6).in_time_zone(@user_time_zone)
                  .beginning_of_day.utc
        else
          date.to_datetime.in_time_zone(@user_time_zone).beginning_of_day.utc
        end
      end

      def end_date(date)
        if date.nil? || date.empty?
          DateTime.now.in_time_zone(@user_time_zone).end_of_day.utc
        else
          date.to_datetime.in_time_zone(@user_time_zone).end_of_day
        end
      end

      def ts_start
        @ts_start ||= check_start
      end

      def ts_end
        @ts_end ||= check_end
      end

      def check_start
        t = Clamp.where(device_id: @device.id).where('time <= ?', @time_start)
                 .order(time: :asc).last
        t_idle = Clamp.where(device_id: @device.id)
                      .where('time > ?', @time_start).order(time: :asc).first
        if t.nil? && t_idle.present?
          t_idle.time > @time_end ? nil : t_idle.time
        elsif t.present? && t_idle.nil?
          nil
        else
          @time_start
        end
      end

      def check_end
        t = Clamp.where(device_id: @device.id).where('time >= ?', @time_end)
                 .order(time: :asc).first
        t_idle = @device.packets.where(type: '85').order(created_at: :asc).last
        if t.nil? && t_idle.present?
          t_idle.created_at < @time_start ? nil : t_idle.created_at
        elsif t.present? && t_idle.nil?
          nil
        else
          @time_end
        end
      end
    end
  end
end
