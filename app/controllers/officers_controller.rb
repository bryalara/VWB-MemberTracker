class OfficersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_userlogin!
  
  def index
    @officers = Officer.all
  end

  def create 
    @officer = Officer.create(officer_params)
    @officer.image.attach(officer_params[:image])

    if @officer.save
      redirect_to officers_path
    else
      render :new
    end
  end


  def show
    @officer = Officer.find(params[:id])
  end

  def new
    @officer = Officer.new
  end

  def edit
    @officer = Officer.find(params[:id])
    
  end

  def update
    @officer = Officer.find(params[:id])
    @officer.image.purge
    @officer.image.attach(officer_params[:image])
    flash[:notice] = "Picture successfully uploaded"
    if @officer.update(officer_params)
      redirect_to officers_path
    else
      render :edit
    end
  end

  def picture
    @officer = Officer.image
    if @officer.empty?
      @officer= image_tag("defaultOfficerImage.png", alt: Officer.name)
    end
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


  def officer_params
    params.require(:officer).permit( :name, :email, :description,:image)
  end
  
end
