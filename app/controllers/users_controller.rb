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
	  if @user.requestDukeAPI_people && @user.save
	    sign_in(@user)
	    flash[:success] = "Welcome to Agend!"
	    redirect_to @user
	  else
	    redirect_to new_user_path, flash: { error: "Invalid Net-ID" }
	  end
	end

	def edit
	end
  
	def show
		@allCourses
		@myCourses
		if current_user.instructor # if instructor, myCourses is the list of all courses that user "has"
			@myCourses = current_user.courses
			@allCourses = Course.all
		else	# if student, takes list of course ids
			course_ids = Marshal.load(current_user.student_courses)
			@myCourses = Course.where(crse_id: course_ids)
			@allCourses = Course.all - @myCourses
		end
	end

	def user_add_course
		course_ids = Marshal.load(current_user.student_courses)
		@myCourses = Course.where(crse_id: course_ids)
		@allCourses = Course.all - @myCourses
		@allCourses.sort! { |a,b| [a.subject, a.catalog_nbr, a.course_title_long] <=> [b.subject, b.catalog_nbr, b.course_title_long] }
	end

	def student_add_course
		if !current_user.nil?
			course_ids = Marshal.load(current_user.student_courses)
			course_ids.push(params[:course_id])
			current_user.update_attribute(:student_courses, Marshal.dump(course_ids))
		end
		redirect_to user_path(current_user)
	end

	def student_remove_course
		if !current_user.nil?
			course_ids = Marshal.load(current_user.student_courses)
			course_ids.delete(params[:course_id])
			current_user.update_attribute(:student_courses, Marshal.dump(course_ids))
		end
		redirect_to user_path(current_user)
	end

	def destroy
	end

  private
  
  def user_params
    params.require(:user).permit(:id, :net_id, :password, :password_confirmation, :instructor, :student_courses)
  end

end
