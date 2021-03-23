# frozen_string_literal: true

class Edithomepage < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
end
