# frozen_string_literal: true

class EventAttendee < ApplicationRecord
  validate :not_full, on: :create
  validate :on_time, on: :create

  belongs_to :user
  belongs_to :event

  has_many_attached :documents
  validates :documents, FILE_VALIDATIONS

  def not_full
    return true if event.capacity.zero?
    return true unless event.capacity < event.users.size + 1

    errors.add('Cannot join event because the capacity has been reached.')
  end

  def on_time
    return true if (DateTime.now <= event.endDate)

    errors.add('Cannot join event because the event\'s time has already passed.')
  end
end
