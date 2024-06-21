class LogRecord < ApplicationRecord
  belongs_to :employee

  validates :time_in, presence: true
  validates :time_out, presence: true
  validate :time_out_after_time_in
  validates :employee, presence: true

  def time_out_after_time_in
    return if time_out.blank? || time_in.blank?

    if time_out < time_in
      errors.add(:time_out, "must be after the time in")
    end
  end
end
