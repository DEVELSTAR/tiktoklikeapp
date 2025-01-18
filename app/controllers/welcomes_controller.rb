class WelcomesController < ApplicationController
	skip_before_action :authenticate_user!, except: [:dashboard]

	def landing
	end

	def contact_us
	end

	def about_us
	end

	def dashboard
      @posts = Post.order(created_at: :desc)
      @user = current_user
	  @posts_liked_by_me = Post.joins(:likes).where(likes: { user_id: current_user.id }).order(created_at: :desc)
	  @my_posts_liked_by_others = Post.where(user_id: current_user.id)
	                                 .joins(:likes)
	                                 .where.not(likes: { user_id: current_user.id })
	                                 .order(created_at: :desc)
	  @posts_liked_by_anyone = Post.joins(:likes).distinct.order(created_at: :desc)
      @all_liked_posts = Post.joins(:likes).distinct.order(created_at: :desc)	  
	  @my_comments_count = current_user.comments.where(parent_id: nil).count
	  @my_reply_count = current_user.comments.where.not(parent_id: nil).count
	  @comments_count = Comment.where(parent_id: nil).count
	  @reply_count = Comment.where.not(parent_id: nil).count
	end

	def clinic
	end

	def school
	end
end
