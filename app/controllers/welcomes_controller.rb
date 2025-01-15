class WelcomesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:landing]

	def landing
	end

	def contact_us
	end

	def about_us
	end

	def dashboard
      @posts = Post.all
	end
end
