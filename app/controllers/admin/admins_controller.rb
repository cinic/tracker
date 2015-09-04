class Admin::AdminsController < Admin::BaseController
  before_action :set_admin_admin, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:new, :create, :edit, :update, :destroy]

  # GET /admin/admins
  # GET /admin/admins.json
  def index
    @admin_admins = Admin::Admin.all
  end

  # GET /admin/admins/1
  # GET /admin/admins/1.json
  def show
  end

  # GET /admin/admins/new
  def new
    @admin_admin = Admin::Admin.new
  end

  # GET /admin/admins/1/edit
  def edit
  end

  # POST /admin/admins
  # POST /admin/admins.json
  def create
    @admin_admin = Admin::Admin.new(admin_admin_params)

    respond_to do |format|
      if @admin_admin.save
        format.html { redirect_to @admin_admin, notice: 'Admin was successfully created.' }
        format.json { render action: 'show', status: :created, location: @admin_admin }
      else
        format.html { render action: 'new' }
        format.json { render json: @admin_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/admins/1
  # PATCH/PUT /admin/admins/1.json
  def update
    respond_to do |format|
      if @admin_admin.update(admin_admin_params)
        format.html { redirect_to @admin_admin, notice: 'Admin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @admin_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/admins/1
  # DELETE /admin/admins/1.json
  def destroy
    @admin_admin.destroy
    respond_to do |format|
      format.html { redirect_to admin_admins_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_admin
      @admin_admin = Admin::Admin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_admin_params
      if superadmin?
        params.require(:admin_admin).permit(:name, :role, :email, :password)
      else
        params.require(:admin_admin).permit(:name, :email, :password)
      end
    end

    def check_admin
      render(:file => File.join(Rails.root, 'public/422.html'), :status => 422, :layout => false) unless superadmin?
    end

end
