module UserHelper
  def sign_in(user)
    user = User.where(:email => user.email.to_s).first if user.is_a?(Symbol)
    request.session[:user_id] = user.id
  end

  def sign_in_admin(user)
    user = Admin::Admin.where(:email => user.email.to_s).first if user.is_a?(Symbol)
    request.session[:admin] = user.id
  end

  def valid_session
    controller.stub!(:logged_in?).and_return(true)
  end
end