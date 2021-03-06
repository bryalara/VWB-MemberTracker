# frozen_string_literal: true

class PointEvent < ApplicationRecord
  # setup to make sure some fields are always filled in
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :point_event_attendees, dependent: :destroy
  has_many :users, through: :point_event_attendees

  has_many_attached :documents
  validates :documents, FILE_VALIDATIONS

  # Displays the capacity of the point_event passed in.
  def self.display_capacity(point_event)
    if point_event.capacity.positive?
      "#{point_event.users.size} / #{point_event.capacity}"
    else
      "#{point_event.users.size} / No Limit"
    end
  end

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

  # import csv
  def self.my_import(file)
    events = []
    wmsg = []
    begin
      CSV.foreach(file.path, headers: true) do |row|
        # puts('READING FROM CSV..........................................')
        # puts(row.to_h[1])
        events << PointEvent.new(row.to_h)
      end
    rescue StandardError
      # puts('Error reading specified csv file, maybe no csv selected')
      wmsg.append('Error reading specified csv file')
    end
    events.each do |event|
      # puts("#{event.name}")

      unless wmsg.first == 'Error reading specified csv file'
        if event.save
          wmsg.append("New event: #{event.name} created")
          # puts("New event: #{event.name} created")
        else
          # puts("Error with event: #{event.name}, might already exist")
          wmsg.append("Error with event: #{event.name}, might already exist")
          if @event.valid?
            wmsg.append("New event: #{event.name} created")
          else
            wmsg.append(event.errors.full_messages[0])
            # puts(event.errors.full_messages[0])
          end
        end
      end
    rescue StandardError
      # puts(e)
    end
  end

  # import csv
  def self.my_import_part(file)
    # events = []
    wmsg = []
    begin
      CSV.foreach(file.path, headers: true) do |row|
        # puts('READING FROM CSV..........................................')
        # puts(row.to_h[1])
        _event_id, event_name, _user_id, user_first, user_second, _user_email, attended, _created_at, _updated_at = row
        @event = PointEvent.find_by(name: event_name)
        @user = User.find_by(firstName: user_first, lastName: user_second)
        if @event && @user
          unless @event.users.find_by(id: user_id)
            @event.users << @user
            @event.save
            if attended
              attendance = PointEventAttendee.find_by(user_id: @user.id, point_event_id: @event.id)
              attendance.attended = true
              attendance.save
            end
          end
        else
          wmsg.append('Some of the events or users do not exist')
        end
      end
    rescue StandardError
      # puts('Error reading specified csv file, maybe no csv selected')
      wmsg.append('Error reading specified csv file')
    end
  end
end
