class ForumPostsController < ApplicationController
  def index
  end

  def new
    @forum_post = ForumPost.new
  end

  def create
    @forum_post = ForumPost.new(forum_post_params)

    flash[:alert] = "Error #{@forum_post.title}"
    render new_forum_post_path, status: :unprocessable_entity
  end

private

  def forum_post_params
    params.expect(forum_post: [ :title, :body ])
  end
end
