class Admin::PingsController < Admin::BaseController
  include Paginate

  def index
    @admin_operational_data_devices =
      data_for_pagination(klass: 'Ping', date_col: :ping_was).order(device_id: :asc, ping_was: :desc)
  end
end
