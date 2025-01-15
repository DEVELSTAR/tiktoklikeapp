class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :create_comment]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @comment = Comment.new
  end

  def like
    @post = Post.find(params[:id])

    if current_user.likes.exists?(post_id: @post.id)
      current_user.likes.find_by(post_id: @post.id).destroy
      redirect_to posts_path, notice: "Post unliked successfully."
    else
      @like = @post.likes.create(user: current_user)
      redirect_to posts_path, notice: "Post liked successfully."
    end
  end

  def create_comment
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: 'Comment added successfully.'
    else
      render :show, alert: 'Failed to add comment.'
    end
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to dashboard_welcomes_path, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to dashboard_welcomes_path, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: 'Post not found.'
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
