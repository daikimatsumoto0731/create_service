class Schedule < ApplicationRecord
  belongs_to :vegetable

  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_must_be_after_start_date

  private

  def end_date_must_be_after_start_date
    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end
end
