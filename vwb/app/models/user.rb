class User < ApplicationRecord
    validates :email, presence: true
    validates :role, presence: true
    validates :firstName, presence: true
    validates :lastName, presence: true
    validates :phoneNumber, presence: true
    validates :classification, presence: true
    validates :tShirtSize, presence: true
    validates :optInEmail, presence: true
    validates :participationPoints, presence: true
end
