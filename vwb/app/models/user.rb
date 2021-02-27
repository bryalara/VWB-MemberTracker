class User < ApplicationRecord
    require 'csv'
    require 'activerecord-import/base'
    require 'activerecord-import/active_record/adapters/postgresql_adapter'

    def self.my_import(file)
        users=[]
        CSV.foreach(file.path, headers: true) do |row|
            users << User.new(row.to_h)
        end
        User.import users, recursive: true
    end
    validates :email, presence: true
    validates :role, presence: true, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
    validates :firstName, presence: true
    validates :lastName, presence: true
    validates :phoneNumber, presence: true
    validates :classification, presence: true
    validates :tShirtSize, presence: true
    validates :optInEmail, presence: true
    validates :participationPoints, presence: true, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
end
