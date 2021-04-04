# frozen_string_literal: true

class PointEventAttendee < ApplicationRecord
  validate :not_full, on: :create
  belongs_to :user
  belongs_to :point_event

  def not_full
    if point_event.capacity < point_event.users.size + 1
      errors.add("Cannot join event because the capacity has been reached.")
    end
  end
end
