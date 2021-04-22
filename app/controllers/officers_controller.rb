# frozen_string_literal: true

class OfficersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin!

  # this is the default page when routed to /officers
  def index
    @officers = Officer.all
  end

  # this is invoked when you add a new element
  def create
    @officer = Officer.create(officer_params)
    # this attaches images when clicked to upload
    @officer.image.attach(officer_params[:image])

    if @officer.save
      redirect_to officers_path
    else
      render :new
    end
  end

  # this is not implemented yet
  def save; end

  # this is for displaying current information
  def show
    @officer = Officer.find(params[:id])
  end

  def new
    @officer = Officer.new
  end

  # this edits the giving parameter that we created in private
  def edit
    @officer = Officer.find(params[:id])
  end

  # this functionality is implemented when you update existing information
  def update
    @officer = Officer.find(params[:id])
    # purge deletes info in the database
    @officer.image.purge
    @officer.image.attach(officer_params[:image])
    flash[:notice] = 'Picture successfully uploaded'

    # this condition is to check if you are editing or updating
    if @officer.update(officer_params)
      redirect_to officers_path
    else
      render :edit
    end
  end

  # not implemented yet
  def picture
    @officer = Officer.image
    @officer = image_tag('defaultOfficerImage.png', alt: Officer.name) if @officer.empty?
  end

  def delete
    @officer = Officer.find(params[:id])
  end

  def destroy
    @officer = Officer.find(params[:id])
    @officer.destroy
    redirect_to officers_path
  end

  private

  # parmeters that are defaulted above
  def officer_params
    params.require(:officer).permit(:name, :email, :description, :image)
  end
end
