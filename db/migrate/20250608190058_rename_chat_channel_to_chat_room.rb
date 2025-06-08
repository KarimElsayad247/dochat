class RenameChatChannelToChatRoom < ActiveRecord::Migration[8.0]
  def change
    rename_table :chat_channels, :chat_rooms
  end
end
