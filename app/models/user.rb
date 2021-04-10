# frozen_string_literal: true

class User < ApplicationRecord
  require 'csv'
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'

  enum role_types: { Member: 0, Admin: 1 }

  # setup the user attributes
  def self.get_users(appr, attr, ord)
    case attr
    when 'first'
      User.where(approved: appr).order("UPPER(\"users\".\"firstName\") #{ord}")
    when 'last'
      User.where(approved: appr).order("UPPER(\"users\".\"lastName\") #{ord}")
    when 'role'
      User.where(approved: appr).order("\"users\".\"role\" #{ord}")
    when 'class'
      User.where(approved: appr).order("CASE \"users\".\"classification\"
                                  WHEN 'Freshman'  THEN '0'
                                  WHEN 'Sophomore' THEN '1'
                                  WHEN 'Junior'    THEN '2'
                                  WHEN 'Senior'    THEN '3'
                                    END #{ord}")
    when 'size'
      User.where(approved: appr).order("CASE \"users\".\"tShirtSize\"
                                  WHEN 'XXXS' THEN '0'
                                  WHEN 'XXS'  THEN '1'
                                  WHEN 'XS'   THEN '2'
                                  WHEN 'S'    THEN '3'
                                  WHEN 'M'    THEN '4'
                                  WHEN 'L'    THEN '5'
                                  WHEN 'XL'   THEN '6'
                                  WHEN 'XXL'  THEN '7'
                                  WHEN 'XXXL' THEN '8'
                                    END #{ord}")
    when 'points'
      User.where(approved: appr).order("\"users\".\"participationPoints\" #{ord}")
    else
      User.where(approved: appr).order('UPPER("users"."lastName") ASC')
    end
  end

  # import a csv to import some initial users
  def self.my_import(file)
    users = []
    wmsg = []
    begin
      CSV.foreach(file.path, headers: true) do |row|
        users << User.new(row.to_h)
      end
    rescue StandardError => e
      wmsg.append('Error reading specified csv file')
    end
    users.each do |user|
      unless wmsg.first == 'Error reading specified csv file'
        if user.save
          wmsg.append("New user: #{user.firstName} #{user.lastName} created")
        else
          wmsg.append("Error with user: #{user.firstName} #{user.lastName}, might already exist")
          if @user.valid?
            wmsg.append("New user: #{user.firstName} #{user.lastName} created")
          else
            wmsg.append(user.errors.full_messages[0])
          end
        end
      end
    rescue StandardError => e
      logger.warn e
    end
    wmsg
  end

  # this is used to get the total points of users
  def get_total_points(user)
    total_points = user.participationPoints # initial points user has
    user.events.each do |event|
      attendance = EventAttendee.find_by(user_id: user.id, event_id: event.id)
      if attendance && attendance.attended
        total_points += event.points # points from events attended
      end
    end
    user.point_events.each do |p_event|
      attendance = PointEventAttendee.find_by(user_id: user.id, event_id: event.id)
      if attendance && attendance.attended
        total_points += p_event.points # points from points events attended
      end
    end
    total_points
  end

  # download the optin email lists to sent group emails
  def self.to_csv
    attributes = %w[email]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.find_each do |user|
        csv << attributes.map { |attr| user.send(attr) } if user.optInEmail == true
      end
    end
  end

  # Returns a list of users matching search parameters
  def self.search(first_name, last_name, email)
    users = User.where("\"firstName\" LIKE ? 
                      AND \"lastName\" LIKE ? 
                      AND email LIKE ?", 
                      "%#{first_name}%", "%#{last_name}%", "%#{email}%")
  end

  # this is to backup the users information by download users' info in a CSV
  def self.to_csv_backup
    # includes all the information a user had
    attributes = %w[email role firstName lastName phoneNumber classification tShirtSize optInEmail approved
                    participationPoints]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  # setup to make sure some fields are always filled in
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 2 }
  validates :firstName, presence: true
  validates :lastName, presence: true
  validates :phoneNumber, presence: true, length: { is: 10 },
                          numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :classification, presence: true
  validates :tShirtSize, presence: true
  validates :optInEmail, inclusion: { in: [true, false] }
  validates :approved, inclusion: { in: [true, false] }
  validates :participationPoints, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :event_attendees, dependent: :destroy
  has_many :events, through: :event_attendees

  has_many :point_event_attendees, dependent: :destroy
  has_many :point_events, through: :point_event_attendees
end
