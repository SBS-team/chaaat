module Api
  class WebhooksController < ApplicationController
    respond_to :json
    def create
      if params[:messages][:message_type]=="system"
        respond_with message=Message.create(message_params)
      end
    end
    def message_params
      params.require(:messages).permit(:body, :attach_path, :room_id)
    end
  end
end
