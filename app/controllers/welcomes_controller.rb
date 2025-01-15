class WelcomesController < ApplicationController
	
	def index
      @posts = Post.all
	end

	def contact_us
	end

	def about_us
	end
end
