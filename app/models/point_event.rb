# frozen_string_literal: true

class PointEvent < ApplicationRecord

  #setup to make sure some fields are always filled in
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true

  has_many :point_event_attendees, dependent: :destroy
  has_many :users, through: :point_event_attendees

  # this is for download all the events
  def self.to_csv
    # below is the all events information that is gonna be downloaded
    attributes = %w[id name description points]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.find_each do |event|
        csv << attributes.map { |attr| event.send(attr) }
      end
    end
  end

  # this is for download all the event-user pairs
  def self.to_csv_users
    attributes = %w[name description startDate endDate points]
    columns = ['event ID', 'event name', 'User 1st name', 'user 2nd name', 'user email']
    # for all events
    CSV.generate(headers: true) do |csv|
      # for all users in this event
      csv << columns
      all.find_each do |event|
        event.users.each do |user|
          # push these things into csv
          csv << [event.id, event.name, user.firstName, user.lastName, user.email]
        end
      end
    end
  end
end
