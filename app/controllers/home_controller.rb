# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @signed_in_user = check_user
    @officers = Officer.all
    @sections = Edithomepage.all.order("created_at ASC")
    @banner = Edithomepage.find_by(name: 'Banner')
    @image_url = @banner.image.attached? == true ?  rails_blob_url(@banner.image[0]) : :''
  end
end
