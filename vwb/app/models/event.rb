class Event < ApplicationRecord
	validates :startDate, presence: true
	validates :endDate, presence:true
	validates :points, presence:true
	validates :name, presence:true
	#validates :description, presence:true
	validates :eventType, presence:true
end
