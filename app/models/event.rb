# frozen_string_literal: true

class Event < ApplicationRecord
  # setup to make sure some fields are always filled in
  validates :startDate, presence: true, unless: :end_date_is_bigger?
  validates :endDate, presence: true, unless: :end_date_is_bigger?
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :event_attendees, dependent: :destroy
  has_many :users, through: :event_attendees

  has_many_attached :documents

  validates :documents, content_type: FILE_VALIDATIONS
  # A validator to ensure an event's end date is later then the start date
  def end_date_is_bigger?
    return if [endDate.blank?, startDate.blank?].any?

    errors.add(:base, 'The end time must be later than the start time') if endDate < startDate
  end

  # Displays a date time in a readable format
  def self.display_date_time(datetime)
    return if datetime.blank?

    datetime.strftime('%Y/%m/%d %I:%M %p')
  end

  # Displays the capacity of the event passed in.
  def self.display_capacity(event)
    if event.capacity.positive?
      "#{event.users.size} / #{event.capacity}"
    else
      "#{event.users.size} / No Limit"
    end
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
    columns = ['event_id', 'event name', 'user_id', 'User 1st name', 'user 2nd name', 'user email']
    # for all events
    CSV.generate(headers: true) do |csv|
      # for all users in this event
      csv << columns
      all.find_each do |event|
        event.users.each do |user|
          # push these things into csv
          # it is int he pair of event-user
          csv << [event.id, event.name, user.id, user.firstName, user.lastName, user.email]
        end
      end
    end
  end

  # import csv
  def self.my_import(file)
    events = []
    wmsg = []
    begin
      CSV.foreach(file.path, headers: true) do |row|
        puts('READING FROM CSV..........................................')
        puts(row.to_h[1])
        events << Event.new(row.to_h)
      end
    rescue StandardError => e
      puts('Error reading specified csv file, maybe no csv selected')
      wmsg.append('Error reading specified csv file')
    end
    events.each do |event|
      puts("#{event.name}")
      begin
        unless wmsg.first == 'Error reading specified csv file'
          if event.save
            wmsg.append("New event: #{event.name} created")
            puts("New event: #{event.name} created")
          else
            puts("Error with event: #{event.name}, might already exist")
            wmsg.append("Error with event: #{event.name}, might already exist")
            if @event.valid?
              wmsg.append("New event: #{event.name} created")
            else
              wmsg.append(event.errors.full_messages[0])
              puts(event.errors.full_messages[0])
            end
          end
        end
      rescue StandardError => e
        puts(e)
      end
    end
  end
end
