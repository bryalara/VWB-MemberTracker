# frozen_string_literal: true

class PointEvent < ApplicationRecord
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true
  # validates :description, presence:true

  has_and_belongs_to_many :users, -> { distinct }
end
