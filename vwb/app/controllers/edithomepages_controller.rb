class EdithomepagesController < ApplicationController
  def index
    @edithomepages = Edithomepage.all
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
    redirect_to edithomepages_path
  end

  def update
    @edithomepage = Edithomepage.find(params[:id])
    @edithomepage.update(edithomepage_params)
  end

  def destroy
    @edithomepage = Edithomepage.find(params[:id])
    @edithomepage.destroy

    redirect_to edithomepages_path
  end

  private

  def edithomepage_params
    params.require(:edithomepage).permit(:name, :description)
  end
end
