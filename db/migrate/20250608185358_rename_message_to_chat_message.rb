class RenameMessageToChatMessage < ActiveRecord::Migration[8.0]
  def change
    rename_table :messages, :chat_messages
  end
end
