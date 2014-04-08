class BackgroundsController < ApplicationController

  def new
    @back = Background.new
  end

  def create
    background = Background.create(bg_params)
    redirect_to background_path(background.id)
  end

  def show
    backgrounds = Background.all.shuffle
    if backgrounds.count > 0
      @background_image = backgrounds.first
    end
  end

private
  def bg_params
    params.require(:background).permit(:path)
  end

end
