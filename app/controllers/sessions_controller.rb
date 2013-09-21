class SessionsController < ApplicationController
  
  def new
    if !current_user.nil?
      redirect_to current_user
    end
  end
  
  def create
    user = User.find_by(net_id: params[:session][:net_id])
      # Authenticate method added by 'has_secure_password'
    if user && user.authenticate(params[:session][:password])
      sign_in(user) # Helper method from SessionsHelper
      # If user was redirected, return to original page. Otherwise, go to 'show' page
      redirect_to(session[:redirect] || user)
      # Delete the redirect key-value pair, if it exists
      session.delete(:redirect)
    else
      flash[:error] = "Invalid username or password"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
