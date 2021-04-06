# frozen_string_literal: true

class Event < ApplicationRecord
  validates :startDate, presence: true, unless: :end_date_is_bigger?
  validates :endDate, presence: true, unless: :end_date_is_bigger?
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :event_attendees, dependent: :destroy
  has_many :users, through: :event_attendees

  def end_date_is_bigger?
    return if [endDate.blank?, startDate.blank?].any?

    errors.add(:endDate, 'must be possible') if endDate < startDate
  end

  def self.display_date_time(datetime)
    return if datetime.blank?
    datetime.strftime('%Y/%m/%d %I:%M %p')
  end

  def self.display_capacity(event)
    if event.capacity > 0
      "#{event.users.size}" + "/" + "#{event.capacity}"
    else
      "#{event.users.size}" + "/" + "No Limit"
    end
  end
end
