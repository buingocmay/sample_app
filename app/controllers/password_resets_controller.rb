class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
    only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".info"
      redirect_to root_url
    else
      flash.now[:danger] = t ".not_f"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(".empty"))
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t ".reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by email: params[:email]
    return if @user
    redirect_to root_path
    flash[:danger] = t "not_f"
  end

  def valid_user
    return redirect_to root_url unless @user&.activated? &&
                                       @user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "expired"
    redirect_to new_password_reset_url
  end
end
