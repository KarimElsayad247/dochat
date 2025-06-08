# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  body          :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  forum_post_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_comments_on_forum_post_id  (forum_post_id)
#  index_comments_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (forum_post_id => forum_posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :forum_post
  
  validates :body, presence: true
end
