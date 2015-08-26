class SubsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :require_moderator, only: [:edit, :update, :destroy]

  def index
    @subs = Sub.all
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = current_user.subs.new(sub_params)

    if @sub.save
      flash[:notices] = ["Successfully created #{@sub.title}!"]
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = current_user.subs.find_by_id(params[:id])
  end

  def update
    @sub = current_user.subs.find_by_id(params[:id])

    if @sub.update(sub_params)
      flash[:notices] = ["Successfully updated #{@sub.title}!"]
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def show
    @sub = Sub.find(params[:id])
    join_votes =
      "LEFT OUTER JOIN votes \
        ON votes.votable_id = posts.id \
        AND votes.votable_type = 'Post'"

    @posts = @sub.posts.includes(:votes)
      .joins(join_votes)
      .group("posts.id")
      .order("COALESCE(SUM(votes.value), 0) DESC")

    render :show
  end

  def destroy
    @sub = Sub.find(params[:id])
    @sub.destroy

    redirect_to subs_url
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def require_moderator
    sub = Sub.find(params[:id])

    redirect_to subs_url if current_user != sub.moderator
  end

end
