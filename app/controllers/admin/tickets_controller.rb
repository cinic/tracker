class Admin::TicketsController < Admin::BaseController
  before_action :ticket, only: [:show, :edit, :update]
  include Paginate

  def index
    @admin_tickets =
      data_for_pagination(klass: 'Ticket', date_col: :created_at)
      .order(created_at: :desc)
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @admin_ticket.update(ticket_params)
        format.html { redirect_to admin_ticket_path(@admin_ticket.id), notice: t('views.ticket.successfully_updated') }
        format.json { render :show, status: :ok, location: @admin_ticket }
      else
        format.html { render :edit }
        format.json { render json: @admin_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def ticket
    @admin_ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:subject, :user_id, :device_id, :text, :close)
  end
end
