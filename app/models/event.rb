# frozen_string_literal: true

class Event < ApplicationRecord
  validates :startDate, presence: true, unless: :endDateIsBigger?
  validates :endDate, presence: true, unless: :endDateIsBigger?
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true
  # validates :description, presence:true

  has_and_belongs_to_many :users, -> { distinct }

  def endDateIsBigger?
    return if [endDate.blank?, startDate.blank?].any?

    errors.add(:endDate, 'must be possible') if endDate < startDate
  end

  def self.dateTimeDisplay(datetime)
    return if datetime.blank?

    datetime.strftime('%Y/%m/%e %I:%M %p')
  end

  #this is for download all the events
  def self.to_csv
    attributes = %w{id name description startDate endDate points}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |event|
        csv << attributes.map{ |attr| event.send(attr) }
      end
    end
  end

  #this is for download all the event-user pairs
  def self.to_csv_users
    attributes = %w{name description startDate endDate points}
    columns = ["event ID", "event name", "User 1st name", "user 2nd name", "user email"]
    #for all events
    CSV.generate(headers: true) do |csv|
      #for all users in this event
      csv << columns
      all.each do |event|
        event.users.each do |user|
          csv << [event.id, event.name, user.firstName, user.lastName, user.email]
        end
      end
    end
  end
end
