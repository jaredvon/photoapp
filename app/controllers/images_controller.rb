class ImagesController < ApplicationController
  
  skip_before_action :verify_authenticity_token,only:[:create]
  
  helper_method :set_file_size
  
  def show
    @image = Image.find(params[:id])
  end

  def index
    @images = current_user.images
    session[:room] = current_user.id
  end
  
  def create
    current_user.images.build(image: params[:myfile]).save
    @image = current_user.images.last
    ActionCable.server.broadcast "image_room_#{current_room}",(render partial:"shared/action_cable_image") 
  end 
  
  private
  
  def set_file_size 
    case current_user.plan
    when "premium"
      return "5000000"
    when "amaze"
      return "20000000"
    end
  end
  
end
