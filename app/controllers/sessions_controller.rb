class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if @user
      log_in_user!(@user)
      render text: "Session Created #{@user.username}!"
    else
      flash.now[:errors] = "Invalid username/password combination"
      render :new
    end
  end

  def destroy
    current_user.log_out_user! if logged_in?
    redirect_to new_session_url
  end
end
