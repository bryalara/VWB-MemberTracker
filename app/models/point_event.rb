# frozen_string_literal: true

class PointEvent < ApplicationRecord
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true

  has_many :point_event_attendees
  has_many :users, :through => :point_event_attendees
end
