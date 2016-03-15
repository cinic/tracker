module API
  module V1
    class DevicesController < API::V1::BaseController
      before_action :set_resource, only: [:show, :update, :states, :modes,
                                          :modes_mini, :perfomance,
                                          :perfomance_mini, :times_mini,
                                          :consumption_mini, :summary_table]
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
        @confirmed = current_user.devices.confirmed
                                 .page(page_params[:page])
                                 .per(page_params[:per_page])

        @unconfirmed = current_user.devices.unconfirmed
                                   .page(page_params[:page])
                                   .per(page_params[:per_page])

        render json: { confirmed: @confirmed,
                       unconfirmed: @unconfirmed }.to_json
      end

      def states
        @states = get_resource.states.order(datetime: :desc)
                              .page(page_params[:page])
                              .per(page_params[:per_page])
        render json: @states.to_json
      end

      def modes
        @modes = API::V1::Device.new(get_resource.id).modes
        render json: @modes.to_json
      end

      def modes_mini
        @modes = API::V1::Device.new(get_resource.id).modes_mini
        render json: @modes.to_json
      end

      def perfomance
        @modes = API::V1::Device.new(get_resource.id).perfomance
        render json: @modes.to_json
      end

      def perfomance_mini
        @modes = API::V1::Device.new(get_resource.id).perfomance_mini
        render json: @modes.to_json
      end

      def times_mini
        @modes = API::V1::Device.new(get_resource.id).cycle_times_mini
        render json: @modes.to_json
      end

      def consumption_mini
        @modes = API::V1::Device.new(get_resource.id).consumption_mini
        render json: @modes.to_json
      end

      def summary_table
        @modes = API::V1::Device.new(get_resource.id,
                                     query_params['start_date'],
                                     query_params['end_date'],
                                     current_user.time_zone).summary_table
        render json: @modes.to_json
      end

      private

      def device_params
        params.require(:device)
              .permit(
                :name, :sensor_readings, :schedule, :description, :imei,
                :slot_number, :interval, :normal_cycle, :material_consumption,
                :device_type, :min_cycle, :max_cycle
              )
      end

      def query_params
        params.permit(:id, :format, :locale, :start_date, :end_date)
      end

      def set_resource(resource = nil)
        resource ||= current_user.devices.confirmed.find(query_params[:id])
        instance_variable_set("@#{resource_name}", resource)
      end
    end
  end
end
