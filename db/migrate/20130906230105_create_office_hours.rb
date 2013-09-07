class CreateOfficeHours < ActiveRecord::Migration
  def change
    create_table :office_hours do |t|
      t.belongs_to	:course
      t.date				:date
      t.time				:start_time
      t.time				:end_time
      t.string 			:location
      t.string 			:description
			t.boolean 		:default, default: true
      t.timestamps
    end
    add_index :office_hours, :course_id
  end
end
