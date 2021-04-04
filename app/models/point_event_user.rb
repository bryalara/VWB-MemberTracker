class PointEventUser < ApplicationRecord
  belongs_to :user
  belongs_to :point_event
  has_one_attached :form
end
