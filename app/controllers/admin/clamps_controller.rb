class Admin::ClampsController < Admin::BaseController
  include Paginate

  def index
    @admin_operational_data_devices =
      data_for_pagination(klass: 'Clamp', date_col: :time).order(time: :desc, device_id: :asc)
  end
end
