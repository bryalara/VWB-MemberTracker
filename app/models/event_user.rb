class EventUser < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_one_attached :form
end
