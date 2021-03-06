class Event < ApplicationRecord
	validates :startDate, presence: true, unless: :endDateIsBigger?
	validates :endDate, presence: true, unless: :endDateIsBigger?
	validates :points, presence:true, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
	validates :name, presence:true
	#validates :description, presence:true
	validates :eventType, presence:true

	has_and_belongs_to_many :users, :before_add => :validate_not_duplicate

	def endDateIsBigger?
		return if [endDate.blank?, startDate.blank?].any?
		if endDate < startDate
			errors.add(:endDate, 'must be possible')
		end
	end

	def self.dateTimeDisplay(datetime)
		return if datetime.blank?
		datetime.strftime("%Y/%m/%e %I:%M %p")
	end

	private
	def validate_not_duplicate(user)
		rails "user already has these points" if users.include? user
	end
end
