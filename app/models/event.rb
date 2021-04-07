# frozen_string_literal: true

class Event < ApplicationRecord
  # setup to make sure some fields are always filled in
  validates :startDate, presence: true, unless: :end_date_is_bigger?
  validates :endDate, presence: true, unless: :end_date_is_bigger?
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true

  has_many :event_attendees, dependent: :destroy
  has_many :users, through: :event_attendees

  # check if the end date is bigger than start date, if not, show error
  def end_date_is_bigger?
    return if [endDate.blank?, startDate.blank?].any?

    errors.add(:endDate, 'must be possible') if endDate < startDate
  end

  def self.date_time_display(datetime)
    return if datetime.blank?

    datetime.strftime('%Y/%m/%e %I:%M %p')
  end

  # this is for download all the events
  def self.to_csv
    # below is the all events information that is gonna be downloaded
    attributes = %w[id name description startDate endDate points]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.find_each do |event|
        csv << attributes.map { |attr| event.send(attr) }
      end
    end
  end

  # this is for download all the event-user pairs
  def self.to_csv_users
    columns = ['event ID', 'event name', 'User 1st name', 'user 2nd name', 'user email']
    # for all events
    CSV.generate(headers: true) do |csv|
      # for all users in this event
      csv << columns
      all.find_each do |event|
        event.users.each do |user|
          # push these things into csv
          # it is int he pair of event-user
          csv << [event.id, event.name, user.firstName, user.lastName, user.email]
        end
      end
    end
  end
end
