class Posts::VersionsController < ApplicationController
  before_action :set_post

  def index
    @post_versions = @post.post_versions
  end

  def show
    @post_version = @post.post_versions.find(params[:id])
  end

  private

    def set_post
      @post = Post.find_by(slug: params[:post_slug])

      if @post.blank?
        render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
      end
    end
end
