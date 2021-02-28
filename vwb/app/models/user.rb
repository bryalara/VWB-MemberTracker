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
    validates :email, presence: true, uniqueness: true
    validates :role, presence: true, numericality: {only_integer: true, :greater_than_or_equal_to => 0, :less_than =>2}
    validates :firstName, presence: true
    validates :lastName, presence: true
    validates :phoneNumber, presence: true, length: {is: 10}
    validates :classification, presence: true
    validates :tShirtSize, presence: true
    validates :participationPoints, presence: true, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
end
