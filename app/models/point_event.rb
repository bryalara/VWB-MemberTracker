# frozen_string_literal: true

class PointEvent < ApplicationRecord
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :point_event_attendees, dependent: :destroy
  has_many :users, through: :point_event_attendees

  def self.display_capacity(point_event)
    "#{point_event.users.size}" + "/" + "#{point_event.capacity}"
  end

end
