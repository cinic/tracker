class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  # GET /devices
  # GET /devices.json
  def index
    @devices = current_user.devices
  end

  # GET /devices/1
  # GET /devices/1.json
  def show

  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
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

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    device_params.delete('imei')
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to devices_url, notice: t('views.device.device_successfully_updated') }
        format.json { render action: 'index', status: :accepted }
      else
        format.html { render action: 'edit' }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = current_user.devices.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def device_params
    params.require(:device)
      .permit(
        :name, :imei, :interval, :slot_number, :normal_cycle,
        :material_consumption, :sensor_readings, :schedule, :description
      )
  end
end
