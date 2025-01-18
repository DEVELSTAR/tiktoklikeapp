class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    case params[:filter]
    when 'my_posts'
      @posts = current_user.posts.order(created_at: :desc)
    when 'all'
      @posts = Post.all.order(created_at: :desc)
    when 'posts_liked_by_me'
      @posts = Post.joins(:likes).where(likes: { user_id: current_user.id }).order(created_at: :desc)
    when 'my_posts_liked_by_others'
      @posts = Post.where(user_id: current_user.id)
                                       .joins(:likes)
                                       .where.not(likes: { user_id: current_user.id })
                                       .order(created_at: :desc)
    when 'all_liked_posts'
      @posts = Post.joins(:likes).distinct.order(created_at: :desc)
    else
      if params[:user_email].present?
        user = User.find_by(email: params[:user_email])
        @posts = user ? user.posts.order(created_at: :desc) : Post.none
      else
        @posts = Post.all.order(created_at: :desc)
      end
    end
  end

  def show
    @comment = Comment.new
    @post = Post.includes(:comments).find(params[:id])
    @comments = @post.comments.where(parent_id: nil).order(created_at: :desc)
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

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: 'Post was successfully updated.'
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
    params.require(:post).permit(:title, :content, images: [])
  end
end
