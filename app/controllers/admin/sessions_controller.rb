class Admin::SessionsController < Admin::BaseController
  skip_before_filter :login_required, only: [:new, :create]
  layout "admin_login"

  def new
  end

  def create
    admin = Admin::Admin.authenticate(params[:email], params[:password])

    if admin
      admin.track_on_login(request)
      sign_in admin if params[:remember_me]
      session_create admin.id
      
      redirect_back_or admin_root_url, notice: "Logged in successfully."
    else
      flash.now.alert = "Неправильный email или пароль, возможно вы регистрировались под другим email'ом?"
      render 'new'
    end
  end

  def destroy
    sign_out
    session_destroy

    redirect_to admin_login_url, notice: "You have been logged out."
  end
end
