# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @signed_in_user = check_user
    @officers = Officer.all
    @sections = Edithomepage.all.order("created_at ASC")
  end
end
