class PointEvent < ApplicationRecord
	validates :points, presence:true, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
	validates :name, presence:true
	#validates :description, presence:true
	validates :eventType, presence:true
end
