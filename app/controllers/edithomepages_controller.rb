# frozen_string_literal: true

class EdithomepagesController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin!, :member_check

  def index
    @edithomepages = Edithomepage.all.order("created_at ASC")
  end

  def show
    @edithomepage = Edithomepage.find(params[:id])
  end

  def new
    @edithomepage = Edithomepage.new
  end

  def edit
    @edithomepage = Edithomepage.find(params[:id])
  end

  def create
    @edithomepage = Edithomepage.create(edithomepage_params)
    if @edithomepage.save
      redirect_to edithomepages_path
    else
      render :new
    end
  end

  def update
    @edithomepage = Edithomepage.find(params[:id])
    if @edithomepage.image.attached?
      if edithomepage_params[:image]
        Rails.logger.info 'Purging current images to add new upload'
        @edithomepage.image.purge
      end
    end
    if @edithomepage.update(edithomepage_params)
      redirect_to edithomepages_path
    else
      render :edit
    end
  end

  def delete
    @edithomepage = Edithomepage.find(params[:id])
  end

  def destroy
    @edithomepage = Edithomepage.find(params[:id])
    @edithomepage.image.purge
    @edithomepage.destroy

    redirect_to edithomepages_path
  end

  private

  def edithomepage_params
    params.require(:edithomepage).permit(:name, :description, :h1, :d1, :h2, :d2, image: [])
  end

  def image_params
    params.require(:edithomepage).permit(:image)
  end
end
