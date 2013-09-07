class OfficeHour < ActiveRecord::Base
	belongs_to :course
	default_scope -> { order('start_date DESC') }
	validates :course_id, presence: true
	validates :date, presence: true, :if => :valid_start_date?
	validates :start_time, presence: true, :if => :valid_start_date?
	validates :end_time, presence: true, :if => :valid_end_date?
	validates :location,  presence: true
	validates :description, length: { maximum: 200 }
	validate :not_past_start, :not_past_end, :valid_date_diff
  validates :default, :inclusion => {:in => [true, false]}
private 
  def valid_start_date?
    ((DateTime.parse(start_date) rescue ArgumentError) == ArgumentError)
  end

  def valid_end_date?
    ((DateTime.parse(end_date) rescue ArgumentError) == ArgumentError)
  end

  def not_past_start
    if start_date && start_date < Date.today
      errors.add(:start_date, "You cannot start an office hour session in the past.")
    end
  end

  def not_past_end
    if end_date && end_date < Date.today
      errors.add(:end_date, "You cannot end and office hour session in the past.")
    end
  end

  def valid_date_diff
  	if start_date.to_i() > end_date.to_i()
  		errors.add(:base, "The end time must be later than the start time.")
  	end
  end
end