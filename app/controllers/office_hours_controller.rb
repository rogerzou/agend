class OfficeHoursController < ApplicationController

	def new
		@newOfficeHour = OfficeHour.new
		@courses = current_user.courses
	end

	def show
		@course = Course.find(params[:id])
	end

	def create
		@newOfficeHour = OfficeHour.new(office_hour_params)
		if @newOfficeHour && @newOfficeHour.save
			flash[:success] = "New office hour added"
			if params[:thisCourse].nil?
				redirect_to office_hours_path
			else
				redirect_to course_path(params[:thisCourse])
			end
		else
			flash[:error] = "Problem with adding office hour session."
			redirect_to new_office_hour_path
		end
	Rails.logger.info(@newOfficeHour.errors.inspect) 
	end

	def index
		@courses
		if !current_user.nil?
			if current_user.instructor
				@courses = current_user.courses
			else
				course_ids = Marshal.load(current_user.student_courses)
				@courses = Course.where(crse_id: course_ids)
			end
		end
	end

	def destroy
		@office_hour = OfficeHour.find(params[:id])
		@office_hour.destroy
		puts params[:thisCourse]
		if params[:thisCourse].nil?
			redirect_to office_hours_path
		else
			redirect_to course_path(params[:thisCourse])
		end
	end

	private

	def office_hour_params
	 	params.require(:office_hour).permit(:id, :course_id, :date, :start_time, :end_time, :location, :description, :default)
  end

end
