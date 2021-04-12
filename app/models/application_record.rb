# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  FILE_VALIDATIONS = {
    content_type: ['image/gif',
                   'image/jpeg',
                   'application/pdf',
                   'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                   'application/msword',
                   'application/vnd.ms-excel',
                   'application/vnd.ms-powerpoint',
                   'application/vnd.openxmlformats-officedocument.presentationml.presentation',
                   'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                   'text/csv',
                   'text/plain']
  }.freeze
end
