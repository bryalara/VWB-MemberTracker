# frozen_string_literal: true

class EventAttendee < ApplicationRecord
  validate :not_full, on: :create
  belongs_to :user
  belongs_to :event

  def not_full
    return true if event.capacity == 0
    return true unless (event.capacity < event.users.size + 1)
    
    errors.add("Cannot join event because the capacity has been reached.")
  end
end
