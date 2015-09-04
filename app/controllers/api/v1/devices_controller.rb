module API
  module V1
    class DevicesController < API::V1::BaseController
      def create
        set_resource(resource_class.new(resource_params))
        if get_resource.save
          render json: { message: t('views.device.device_successfully_added') },
                 status: :created
        else
          render json: get_resource.errors, status: :unprocessable_entity
        end
      end

      def index
        plural_resource_name = "@#{resource_name.pluralize}"
        resources = current_user.devices.includes(:states, :pings)
                      .page(page_params[:page])
                      .per(page_params[:per_page])

        instance_variable_set(plural_resource_name, resources)
        respond_with instance_variable_get(plural_resource_name)
      end

      def states
        @states = current_user.devices.includes(:states).find(device_id).states
                    .page(page_params[:page])
                    .per(page_params[:per_page])
        respond_with @states
      end

      def graph
        triggers, graph = [], []
        klass = time_diff_graph.nil? ? Modes::OneDay : Object.const_get(time_diff_graph)

        data =
          if time_diff_graph.nil?
            klass.where(device_id: device_id).order(time: :asc)
          else
            klass.where(
              device_id: device_id,
              time: start_date.in_time_zone(time_zone).utc..end_date.in_time_zone(time_zone).utc
            ).order(time: :asc)
          end

        data.each do |item|
          triggers << { time: item[:time].in_time_zone(time_zone), type: item[:chrono_type] }
        end

        triggers.each_with_index do |val, index|
          if index > 0 && val != triggers.last
            next if triggers[index - 1][:chrono_type] == val[:chrono_type]
          end
          graph << val
        end

        instance_variable_set('@graph_data', graph)
        respond_with instance_variable_get('@graph_data')
      end

      def modes
        modes = []
        klass = time_diff_modes.nil? ? Modes::OneDay : Object.const_get(time_diff_modes)

        #render json: { error: t('api.errors.graph.no_date') }, status: :unprocessable_entity
        data =
          if time_diff_modes.nil?
            klass.where(device_id: device_id).order(time: :asc)
          else
            klass.where(
              device_id: device_id,
              time: start_date.in_time_zone(time_zone).utc..end_date.in_time_zone(time_zone).utc
            ).order(time: :asc)
          end
        data.map do |item|
          modes << { time: item['time'].in_time_zone(time_zone),
                     norm: item['norm'], acl: item['acl'],
                     idle: item['idle'], fail: item['fail'],
                     duration_norm: item['duration_norm'],
                     duration_idle: item['duration_idle'],
                     duration_fail: item['duration_fail'],
                     duration_acl: item['duration_acl'] }
        end

        instance_variable_set('@modes_data', modes)
        respond_with instance_variable_get('@modes_data')
      end

      private

      def device_params
        params.require(:device)
          .permit(
            :name, :imei, :interval, :slot_number, :normal_cycle,
            :material_consumption, :sensor_readings, :schedule, :description
          )
      end

      def query_params
        params.permit(:id, :start_date, :end_date, :format)
      end

      def set_resource(resource = nil)
        resource ||= current_user.devices.find(params[:id])
        instance_variable_set("@#{resource_name}", resource)
      end

      def time_diff_graph
        return if start_date == '' && end_date == '' || start_date.nil? && end_date.nil?
        diff = end_date.to_datetime.to_i - start_date.to_datetime.to_i
        if diff < 10800
          'Clamp'
        elsif diff < 86400
          'Modes::OneMinute'
        elsif diff < 345600
          'Modes::FiveMinute'
        elsif diff < 1814400
          'Modes::ThirtyMinute'
        elsif diff < 2851200
          'Modes::OneHour'
        elsif diff < 15552000
          'Modes::FourHour'
        elsif diff < 69120000
          'Modes::OneDay'
        end
      end

      def time_diff_modes
        return if start_date == '' && end_date == '' || start_date.nil? && end_date.nil?
        diff = end_date.to_datetime.to_i - start_date.to_datetime.to_i
        if diff < 14400
          'Modes::OneMinute'
        elsif diff < 86400
          'Modes::FiveMinute'
        elsif diff < 604800
          'Modes::ThirtyMinute'
        elsif diff < 1209600
          'Modes::OneHour'
        elsif diff < 4320000
          'Modes::FourHour'
        elsif diff >= 4320000
          'Modes::OneDay'
        end
      end

      def device_id
        current_user.devices.find(params[:id]).id
      end

      def start_date
        query_params[:start_date]
      end

      def end_date
        query_params[:end_date]
      end

      def time_zone
        return 'Moscow' if current_user.time_zone.nil?
        current_user.time_zone
      end
    end
  end
end
