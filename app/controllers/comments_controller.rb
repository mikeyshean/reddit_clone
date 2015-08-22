class CommentsController < ApplicationController
  before_action :require_login, except: :show
  before_action :require_author, only: [:edit, :update]

  def new
    @comment = Comment.new(post_id: params[:post_id])
    render :new
  end

  def create
    @comment = current_user.comments.new(comment_params)

    redirect_url =
      if @comment.parent_comment_id.nil?
        post_url(@comment.post)
      else
        comment_url(@comment.parent_comment_id)
      end

    if @comment.save
      redirect_to comment_url(@comment)
    else
      flash.now[:errors] = @comment.errors.full_messages
      redirect_to redirect_url
    end
  end

  def show
    @parent_comment = Comment.find(params[:id])
    @child_comment = @parent_comment
      .child_comments
      .new(post_id: @parent_comment.post_id)

    render :show
  end

  private

  def comment_params
    params.require(:comment)
      .permit(:content, :post_id, :parent_comment_id)
  end

  def require_author
    @comment = Comment.find(params[:id])
    redirect_to comment_url(@comment) if @comment.author != current_user
  end
end
