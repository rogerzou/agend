class UsersController < ApplicationController
	
	before_action :signed_in, only: [:edit, :show, :destroy ]
	
	def new
	  if (current_user.nil?)
	  @user = User.new
	  else
	    redirect_to current_user
	  end
	end

	def create
	  @user = User.new(user_params)
	  if @user.authenticate_duke && @user.save
	    sign_in(@user)
	    flash[:success] = "Account created!"
	    redirect_to @user
	  else
	    render 'new'
	  end
	end

  def edit
  end
  
	def show
		@allCourses = Course.all
		@courses = current_user.courses
		if (current_user.instructor)
			redirect_to controller: "courses", action: "show"
		end
	end

	def destroy
	end

  private
  
  def user_params
    params.require(:user).permit( :net_id, :password, :password_confirmation, :instructor)
  end

end
