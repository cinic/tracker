class Admin::StatesController < Admin::BaseController
  include Paginate

  def index
    @admin_service_device_data = data_for_pagination(klass: 'State').order(created_at: :desc)
  end
end
