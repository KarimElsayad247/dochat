class HmrChannel < ApplicationCable::Channel
  def subscribed
    stream_from Hmr::CHANNEL_NAME
  end
end
