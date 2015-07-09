class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to current_user
    end
  end

  def create
  	user = User.find_by_email(params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		# log_in user
  		# remember user
  		# redirect_to user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to user
  	else
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	cookies.delete(:auth_token)
    flash[:success] = "Logged out !!!"
    redirect_to root_url
  end
end
