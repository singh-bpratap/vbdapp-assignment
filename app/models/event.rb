class Event < ApplicationRecord
  enum status: [:draft, :published]

  acts_as_paranoid

  belongs_to :user

  validates :name, :description, :location, presence: true, if: Proc.new {|e| e.published?}
  validate :has_running_attributes

  before_save :set_missing_running_attribute

  private

  def set_missing_running_attribute
    if !start_date.present?
      self.start_date = end_date - duration.days
    elsif !end_date.present?
      self.end_date = start_date + duration.days
    elsif !duration.present?
      self.duration = (end_date - start_date).to_i + 1
    end
  end

  def has_running_attributes
    if [start_date, end_date, duration].count(nil) > 1
      errors.add(:base, "At least 2 values are mandatory for start_date, end_date and duration.")
    end
  end
end
