class OfficersController < ApplicationController
  def index
    @officers = Officer.all
  end

  def create 
    officer = Officer.create(officer_params)
    redirect_to_officers_path
  end


  def show
    @officer = Officer.find(params[:id])
  end

  def new
  end

  def edit
    @officer = Officer.find(params[:id])
  end

  def update
    @officer = Officer.find(params[:id])
    @officer.update(officer_params)
    redirect_to officer_path(@officer)
  end

  def destroy
    @officer = Officer.find(params[:id])
    @officer.destroy
    redirect_to officers_path
  end
  private


  def officer_params
    params.require(:officer).permit( :name, :email, :photoUrl, :description)
  end
end
