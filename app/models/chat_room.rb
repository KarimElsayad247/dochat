# == Schema Information
#
# Table name: chat_rooms
#
#  id          :bigint           not null, primary key
#  description :string
#  image_url   :string
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_chat_rooms_on_name  (name) UNIQUE
#
class ChatRoom < ApplicationRecord
  has_many :chat_messages, dependent: :destroy
end
