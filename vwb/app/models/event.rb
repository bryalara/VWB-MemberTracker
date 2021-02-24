class Event < ApplicationRecord
	validates :startDate, presence: true, unless: :endDateIsBigger?
	validates :endDate, presence: true, unless: :endDateIsBigger?
	validates :points, presence:true, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
	validates :name, presence:true
	#validates :description, presence:true
	validates :eventType, presence:true

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
end
