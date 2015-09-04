class Admin::DevicesController < Admin::BaseController
  before_action :set_admin_device, only: [:show, :edit, :update, :destroy,
                                          :refill_durations, :refill_data,
                                          :duplicated_clamps, :bad_clamps,
                                          :refill_clamps, :refill_types,
                                          :refill_states, :refill_pings,
                                          :check_packets, :refilter_packets]

  def index
    @admin_devices = Admin::Device.all
  end

  def show
  end

  def new
    @admin_device = Admin::Device.new
  end

  def edit
  end

  def create
    @admin_device = Admin::Device.new(admin_device_params)

    respond_to do |format|
      if @admin_device.save
        format.html { redirect_to @admin_device, notice: 'Device was successfully created.' }
        format.json { render action: 'show', status: :created, location: @admin_device }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_device.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @admin_device.update(admin_device_params)
        format.html { redirect_to @admin_device, notice: 'Device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_device.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_device.destroy
    respond_to do |format|
      format.html { redirect_to admin_devices_url }
      format.json { head :no_content }
    end
  end

  def clamps_destroy
    @admin_device.clamps_destroy
    respond_to do |format|
      format.html { redirect_to @admin_device, notice: 'Clamps was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def states_destroy
    @admin_device.states_destroy
    respond_to do |format|
      format.html { redirect_to @admin_device, notice: 'States was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def refill_data
    @admin_device.refill_data
    respond_to do |format|
      format.html { redirect_to @admin_device, notice: 'Data refill job was successfully created.' }
      format.json { head :no_content }
    end
  end

  def refill_clamps
    @admin_device.refill_clamps
    respond_to do |format|
      format.html { redirect_to @admin_device, notice: 'Clamps refill job was successfully created.' }
      format.json { head :no_content }
    end
  end

  def refill_durations
    @admin_device.refill_durations
    respond_to do |format|
      format.html { redirect_to @admin_device, notice: 'Durations job was successfully created.' }
      format.json { head :no_content }
    end
  end

  def refill_types
    @admin_device.refill_types
    respond_to do |format|
      format.html { redirect_to @admin_device, notice: 'Types job was successfully created.' }
      format.json { head :no_content }
    end
  end

  def refill_states
    @admin_device.refill_states
    respond_to do |format|
      format.html { redirect_to @admin_device, notice: 'States jobs was successfully created.' }
      format.json { head :no_content }
    end
  end

  def refill_pings
    @admin_device.refill_pings
    respond_to do |format|
      format.html { redirect_to @admin_device, notice: 'Pings jobs was successfully created.' }
      format.json { head :no_content }
    end
  end

  def check_packets
    @admin_device.check_packets
    respond_to do |format|
      format.html { redirect_to @admin_device, notice: 'CheckPackets job was successfully created.' }
      format.json { head :no_content }
    end
  end

  def refilter_packets
    @admin_device.refilter_packets
    respond_to do |format|
      format.html { redirect_to @admin_device, notice: 'RefilterPackets job was successfully created.' }
      format.json { head :no_content }
    end
  end

  def duplicated_clamps
    @duplicated_clamps = @admin_device.duplicated_clamps
  end

  def bad_clamps
    @bad_clamps = @admin_device.bad_clamps
  end

  private

  def set_admin_device
    @admin_device = Admin::Device.find(params[:id])
  end

  def admin_device_params
    params.require(:admin_device).permit!
  end
end
