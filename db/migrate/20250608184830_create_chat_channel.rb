class CreateChatChannel < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_channels do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.string :image_url

      t.timestamps
    end
  end
end
