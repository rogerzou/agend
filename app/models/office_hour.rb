=begin
class CreateOfficeHours < ActiveRecord::Migration
  def change
    create_table :office_hours do |t|
      t.belongs_to  :course
      t.date        :date
      t.time        :start_time
      t.time        :end_time
      t.string      :location
      t.string      :description
      t.boolean     :default, default: true
      t.timestamps
    end
    add_index :office_hours, :course_id
  end
end
=end

class OfficeHour < ActiveRecord::Base

	belongs_to :course
	default_scope -> { order('date DESC') }
=begin
	validates :course_id, presence: true
	validates :date, presence: true, :if => :valid_start_date?
	validates :start_time, presence: true, :if => :valid_start_date?
	validates :end_time, presence: true, :if => :valid_end_date?
	validates :location,  presence: true
	validates :description, length: { maximum: 200 }
	validate :not_past_start, :not_past_end, :valid_date_diff
  validates :default, :inclusion => {:in => [true, false]}
=end
private 
  def valid_start_date?
    ((DateTime.parse(start_date) rescue ArgumentError) == ArgumentError)
  end

  def valid_end_date?
    ((DateTime.parse(end_date) rescue ArgumentError) == ArgumentError)
  end

  def not_past_start
    if date && date < Date.today
      errors.add(:start_date, "You cannot start an office hour session in the past.")
    end
  end

  def not_past_end
    if end_time && end_time < Date.today
      errors.add(:end_date, "You cannot end and office hour session in the past.")
    end
  end

  def valid_date_diff
  	if start_time.to_i() > end_time.to_i()
  		errors.add(:base, "The end time must be later than the start time.")
  	end
  end
end