class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show; end

  def edit; end

  def update
    user_params.delete('password') if user_params[:password].blank?
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_user_url, notice: t('views.user.user_successfully_updated') }
        format.json { render action: 'show', status: :accepted }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit!
  end
end
