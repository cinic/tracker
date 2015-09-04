class Admin::PacketsController < Admin::BaseController
  before_action :set_admin_data_device, only: [:show, :edit, :update, :destroy]
  include Paginate

  # GET /admin/data_devices
  # GET /admin/data_devices.json
  def index
    @admin_data_devices = data_for_pagination({klass: 'Packet', where: 'imei_substr'}).order(created_at: :desc)
  end

  # GET /admin/data_devices/1
  # GET /admin/data_devices/1.json
  def show
  end

  # GET /admin/data_devices/new
  def new
    @admin_data_device = Packet.new
  end

  # GET /admin/data_devices/1/edit
  def edit
  end

  # POST /admin/data_devices
  # POST /admin/data_devices.json
  def create
    @admin_data_device = Packet.new(admin_data_device_params)

    respond_to do |format|
      if @admin_data_device.save
        format.html { redirect_to @admin_data_device, notice: 'Data device was successfully created.' }
        format.json { render action: 'show', status: :created, location: @admin_data_device }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_data_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/data_devices/1
  # PATCH/PUT /admin/data_devices/1.json
  def update
    respond_to do |format|
      if @admin_data_device.update(admin_data_device_params)
        format.html { redirect_to @admin_data_device, notice: 'Data device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_data_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/data_devices/1
  # DELETE /admin/data_devices/1.json
  def destroy
    @admin_data_device.destroy
    respond_to do |format|
      format.html { redirect_to admin_packets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_data_device
      @admin_data_device = Packet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_data_device_params
      params[:admin_data_device]
    end
end
