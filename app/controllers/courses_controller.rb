class CoursesController < ApplicationController

	def create
		@newCourse = current_user.courses.new(crse_id: params[:course_id])
		if @newCourse.requestDukeAPI_courses
		 	if @newCourse.save
				flash[:success] = @newCourse.course_title_long + " added!"
			else
				flash[:error] = "Course ID already used!"
			end
		else
			flash[:error] = "Invalid Course ID"
		end
		redirect_to user_path(current_user)
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
