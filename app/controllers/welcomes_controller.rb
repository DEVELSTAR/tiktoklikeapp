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
	end
end
