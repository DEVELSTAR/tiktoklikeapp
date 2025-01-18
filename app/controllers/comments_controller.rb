class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:update, :destroy, :edit]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user

    if params[:comment][:parent_id]
      @comment.parent_id = params[:comment][:parent_id].to_i
    end

    if @comment.save
      redirect_to @post, notice: 'Comment was successfully created.'
    else
      redirect_to @post, alert: 'There was an error creating the comment.'
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'Comment was successfully updated.'
    else
      redirect_to post_path(@post), alert: 'Failed to update comment.'
    end
  end


  def destroy
    if @comment.parent_id
      @comment.destroy
      redirect_to @post, notice: 'Reply was successfully deleted.'
    else
      @comment.destroy
      redirect_to @post, notice: 'Comment was successfully deleted.'
    end
  end


  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
