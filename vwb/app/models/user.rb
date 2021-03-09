class User < ApplicationRecord
    require 'csv'
    require 'activerecord-import/base'
    require 'activerecord-import/active_record/adapters/postgresql_adapter'
    
    enum role_types: [:Member, :Admin]


    def self.my_import(file)
        users=[]
        CSV.foreach(file.path, headers: true) do |row|
            users << User.new(row.to_h)
        end
        User.import users, recursive: true
    end

    def get_total_points(user)
        totalPoints = user.participationPoints
        user.events.each do |event|
            totalPoints += event.points
        end
        user.point_events.each do |pEvent|
            totalPoints += pEvent.points
        end
        totalPoints
    end

    validates :email, presence: true, uniqueness: true
    validates :role, presence: true, numericality: {only_integer: true, :greater_than_or_equal_to => 0, :less_than =>2}
    validates :firstName, presence: true
    validates :lastName, presence: true
    validates :phoneNumber, presence: true, length: {is: 10}
    validates :classification, presence: true
    validates :tShirtSize, presence: true
    validates_inclusion_of :optInEmail, in: [true, false]
    validates_inclusion_of :approved, in: [true, false]
    validates :participationPoints, presence: true, numericality: {only_integer: true, :greater_than_or_equal_to => 0}

    has_and_belongs_to_many :events, -> { distinct }
    has_and_belongs_to_many :point_events, -> { distinct }
end
