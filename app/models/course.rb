class Course < ActiveRecord::Base

	belongs_to :user
	has_many :office_hours
end
class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
    	# Data pulled from Duke Curriculum API
    	t.integer	:crse_id
    	t.string	:subject
    	t.integer	:catalog_nbr
    	t.string	:institution
    	t.string	:acad_career
    	t.string	:course_title_long
    	t.integer	:class_nbr
    	t.string	:ssr_component
    	t.string 	:ssr_mtg_sched_long
    	t.string	:ssr_instr_long
    	t.string	:ssr_mtg_dt_long
    	t.string  :ssr_mtg_loc_long
      t.timestamps
    end
    add_index :courses, :user_id
    add_index	:courses, :subject
    add_index	:courses, :class_nbr
  end
end
