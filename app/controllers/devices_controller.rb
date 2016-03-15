class DevicesController < ApplicationController
  before_action :device, only: [:states, :edit, :update, :destroy]
  before_action :api_device, only: [:show, :modes, :perfomance, :times,
                                    :material_consumption]

  def index; end

  def show; end

  def modes; end

  def perfomance; end

  def times; end

  def material_consumption; end

  def states
    @states = @device.states.limit(10).order(datetime: :desc)
  end

  def new
    @device = Device.new
  end

  def edit
    cookies[:referrer] = request.referrer
  end

  def create
    @device = Device.new(device_params)
    @device.user_id = current_user.id
    respond_to do |format|
      if @device.save
        format.html { redirect_to devices_url, notice: t('views.device.device_successfully_added') }
        format.json { render json: @device.to_json, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    device_params.delete('imei')
    referrer = cookies[:referrer]
    referrer = device_path(query_params) if cookies[:referrer].nil?
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to referrer, notice: t('views.device.device_successfully_updated') }
        format.json { render action: 'index', status: :accepted }
      else
        format.html { render action: 'edit' }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url }
      format.json { head :no_content }
    end
  end

  private

  def device
    @device = current_user.devices.find(params[:id])
  end

  def api_device
    @device ||= current_user.devices.confirmed.find(params[:id])
    @api_device ||= API::V1::Device.new @device.id, query_params['start_date'],
                                        query_params['end_date'],
                                        current_user.time_zone
    @all_stat ||= @api_device.summary_table
  end

  def device_params
    params.require(:device)
          .permit(
            :name, :sensor_readings, :schedule, :description, :imei,
            :slot_number, :interval, :normal_cycle, :material_consumption,
            :device_type, :min_cycle, :max_cycle, :id
          )
  end

  def query_params
    params.permit(:start_date, :end_date)
  end
end
