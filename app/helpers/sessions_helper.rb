module SessionsHelper # Lightweight sessions functionality helper methods
  
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token # Adds remember token to cookies hash
    self.current_user = user
  end

  def signed_in?
    !self.current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  # Assigns argument as 'current_user'
  def current_user=(user)
    @current_user = user
  end
  
  # Calling current user either returns '@current_user, or searches for 
  # user that is registered in the cookies hash if @current_user is nil
  def current_user
    @current_user ||= User.find_by(remember_token: cookies[:remember_token])
  end
  
  def signed_in
    if current_user.nil?
      # Stores original URL after potential redirect b/c of before_action in user controller
      session[:redirect] = request.original_url
      redirect_to new_user_path
    end
  end
  
end
