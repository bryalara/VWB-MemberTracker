class PointEvent < ApplicationRecord
	validates :points, presence:true
	validates :name, presence:true
	#validates :description, presence:true
	validates :eventType, presence:true
end
