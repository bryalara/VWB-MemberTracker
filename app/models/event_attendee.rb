# frozen_string_literal: true

class EventAttendee < ApplicationRecord
  belongs_to :user
  belongs_to :event
end
