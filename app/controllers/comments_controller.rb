class CommentsController < ApplicationController
  allow_unauthenticated_access only: %i[create]

  before_action :set_post

  def create
    unless @post.comments_allowed?
      redirect_to @post, alert: "Comments are disabled for this post."
      return
    end

    @comment = @post.comments.new(comment_params)
    @comment.user = Current.user if authenticated?

    if @comment.save
      redirect_to @post, notice: "Comment posted."
    else
      render "posts/show", status: :unprocessable_entity
    end
  end

  private

    def set_post
      @post = Post.find_by(slug: params[:post_slug])

      if @post.blank?
        render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
      end
    end

    def comment_params
      params.require(:comment).permit(:body, :guest_name, :guest_email)
    end
end
