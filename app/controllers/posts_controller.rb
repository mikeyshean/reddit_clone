class PostsController < ApplicationController
  before_action :require_login, except: :show
  before_action :require_author, only: [:edit, :update]

  def new
    @post = Post.new(sub_ids: [params[:sub_id]])
    render :new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post)
      .permit(:title, :content, :url, :sub_ids => [])
  end

  def require_author
    @post = Post.find(params[:sub_id])
    redirect_to sub_url(@post) if current_user != @post.author
  end
end
