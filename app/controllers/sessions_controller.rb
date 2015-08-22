class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:username],
      params[:password]
    )

    if @user
      log_in_user!(@user)
      render text: "Session Created #{@user.username}!"
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
