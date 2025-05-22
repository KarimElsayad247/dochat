class ChatsController < ApplicationController
  def index
  end

  def send_message
    ActionCable.server.broadcast "chat_Best Room", {
      sent_by: Current.user.username,
      body: Commonmarker.to_html(params[:new_message])
    }
  end

  private

  def new_message_params
    params.expect :new_message
  end
end
