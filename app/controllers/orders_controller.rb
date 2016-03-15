class OrdersController < BaseController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order['user_id'] = current_user.nil? ? '' : current_user.id
    respond_to do |format|
      if @order.save
        format.html { redirect_to new_order_path, notice: t('views.order.successfully_added') }
        format.json { render json: { message: t('views.order.successfully_added') }, status: :created }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :contact, :comment)
  end
end
