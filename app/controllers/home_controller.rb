# frozen_string_literal: true

class HomeController < ApplicationController
  def index 
    @signedInUser= check_user
  end
end
