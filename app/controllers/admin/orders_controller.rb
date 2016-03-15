class Admin::OrdersController < Admin::BaseController
  before_action :order, only: [:edit, :update]
  include Paginate

  def index
    @admin_orders =
      data_for_pagination(klass: 'Order', date_col: :created_at)
      .order(created_at: :desc)
  end

  def edit; end

  def update
    respond_to do |format|
      if @admin_order.update(order_params)
        format.html do
          redirect_to admin_orders_path,
                      notice: t('views.order.successfully_updated')
        end
        format.json { render action: 'index', status: :accepted }
      else
        format.html { render action: 'edit' }
        format.json do
          render json: @admin_order.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def order
    @admin_order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:name, :contact, :comment, :status)
  end
end
