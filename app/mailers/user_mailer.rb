class UserMailer < ActionMailer::Base

  def password_reset(user)
    @user = user
    mail :to => @user.email, :subject => "Password Reset"
  end

  def confirmation_instructions(user)
    @user = user
    mail :to => @user.email, :subject => "Confirmation instructions"
  end
end

