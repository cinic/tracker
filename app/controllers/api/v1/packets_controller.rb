module API
  module V1
    class PacketsController < API::V1::BaseController
      before_action :restrict_access_by_params
      skip_before_action :authenticate_user!

      def create
        set_resource(resource_class.new(resource_params))
        if get_resource.save
          Delayed::Job.enqueue(
            PacketProcess::FilterJob.new(get_resource.id),
            queue: 'packets',
            run_at: 1.minutes.from_now
          )
          render json: { message: 'Data created' }, status: :created,
                 location: api_device_data_path
        else
          render json: get_resource.errors, status: :unprocessable_entity
        end
      end

      private

      def packet_params
        params.require(:device_data)
          .permit(:device_id, :imei, :content, :type, :version, :sim_balance)
      end

      def query_params
        params.permit(:token)
      end

      def restrict_access_by_params
        return if query_params[:token] == '2ade1fbc924fa19d7fdb6a76e8a5ca9a'
        render json: { message: 'Invalid API Token' }, status: 401
      end
    end
  end
end
