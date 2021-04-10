# frozen_string_literal: true

class PointEventAttendee < ApplicationRecord
  validate :not_full, on: :create
  belongs_to :user
  belongs_to :point_event

  has_many_attached :documents

  def not_full
    return true if point_event.capacity.zero?
    return true unless point_event.capacity < point_event.users.size + 1

    errors.add('Cannot join event because the capacity has been reached.')
  end
end
