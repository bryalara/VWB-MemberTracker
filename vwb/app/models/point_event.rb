class PointEvent < ApplicationRecord
	validates :points, presence:true
	validates :name, presence:true
	#validates :description, presence:true
	validates :type, presence:true
end
