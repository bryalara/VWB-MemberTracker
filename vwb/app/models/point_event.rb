class PointEvent < ApplicationRecord
	validates :points, presence:true, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
	validates :name, presence:true
	#validates :description, presence:true
	validates :eventType, presence:true

	has_and_belongs_to_many :users, :before_add => :validate_not_duplicate

	private
	def validate_not_duplicate(user)
		rails "user already has these points" if users.include? user
	end
end
