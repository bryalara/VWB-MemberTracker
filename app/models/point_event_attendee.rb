class PointEventAttendee < ApplicationRecord
    belongs_to :user
    belongs_to :point_event
end