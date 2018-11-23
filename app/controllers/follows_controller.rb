class FollowsController < ApplicationController
  before_action :logged_in_user

  def follows
    @title = t params[:title].to_s
    @user = User.find_by id: params[:id]
    @users = @user.send(params[:title]).page params[:page]
    render :show_follow
  end
end
