# frozen_string_literal: true

class Edithomepage < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  has_many_attached :image
end
