class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    if @user
      log_in_user!(@user)
      flash[:notices] = ["Welcome back, #{@user.username}!"]
      redirect_to subs_url
    else
      flash.now[:errors] = ["Invalid username or password."]
      render :new
    end
  end

  def destroy
    log_out_user! if logged_in?
    redirect_to new_session_url
  end
end
