class UsersController < ApplicationController

	def search
		users=User.where("login like ?", "#{params[:login]}%")
		render :json=>users,:root=>false
	end
end
