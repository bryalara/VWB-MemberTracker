# frozen_string_literal: true

class Event < ApplicationRecord
  validates :startDate, presence: true, unless: :end_date_is_bigger?
  validates :endDate, presence: true, unless: :end_date_is_bigger?
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true

  has_many :event_attendees, dependent: :destroy
  has_many :users, through: :event_attendees

  def end_date_is_bigger?
    return if [endDate.blank?, startDate.blank?].any?

    errors.add(:endDate, 'must be possible') if endDate < startDate
  end

  def self.date_time_display(datetime)
    return if datetime.blank?

    datetime.strftime('%Y/%m/%e %I:%M %p')
  end
end
