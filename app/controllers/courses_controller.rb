class CoursesController < ApplicationController

	def create
		@newCourse = current_user.courses.new(crse_id: params[:course_id])
		if @newCourse.requestDukeAPI_courses && @newCourse.save
			redirect_to user_path(current_user)
			flash[:success] = @newCourse.course_title_long + " added!"
		else
			flash[:error] = "Invalid Course ID"
			redirect_to user_path(current_user)
		end
	end

	def show
		@thisCourse = Course.find(params[:id])
		@myHours = @thisCourse.office_hours
	end

	def destroy
		@course = Course.find(params[:id])
		@course.destroy
		redirect_to user_path(current_user)
	end

end
