class CommentsController < ApplicationController
  before_action :require_login, except: :show
  before_action :require_author, only: [:edit, :update]

  def new
    @comment = Comment.new(post_id: params[:post_id])
    render :new
  end

  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      redirect_to post_url(@comment.post)
    else
      flash[:notices] = @comment.errors.full_messages
      redirect_to new_post_comment_url(@comment.post_id)
    end
  end

  def show
    @parent_comment = Comment.find(params[:id])
    @child_comment = @parent_comment
      .child_comments
      .new(post_id: @parent_comment.post_id)

    render :show
  end

  def upvote
    @comment = Comment.find(params[:id])
    vote = @comment.votes.create(value: 1)
    redirect_to post_url(@comment.post)
  end

  def downvote
    @comment = Comment.find(params[:id])
    vote = @comment.votes.create(value: -1)
    redirect_to post_url(@comment.post)
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
