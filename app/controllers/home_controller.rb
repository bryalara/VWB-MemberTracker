# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @signed_in_user = check_user
    @officers = Officer.all
  end
end
