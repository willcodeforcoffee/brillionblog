class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  before_action :set_post, only: %i[show edit update destroy]

  def index
    respond_to do |format|
      format.html { @posts = authenticated? ? Post.all.recent_first : Post.published.recent_first }
      # The feed is public regardless of who requests it, so it never includes drafts.
      format.rss { @posts = Post.published.recent_first; render layout: false }
    end
  end

  def show
    if @post.draft? && !authenticated?
      render_not_found
      return
    end

    @comment = Comment.new
  end

  def new
    @post = Post.new(author_ids: [ Current.user.id ])
  end

  def create
    @post = Post.new(post_params)
    apply_publish_state
    ensure_current_user_credited

    if @post.save
      @post.record_version!(Current.user)
      redirect_to @post, notice: "Post saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @post.assign_attributes(post_params)
    apply_publish_state
    ensure_current_user_credited

    if @post.save
      @post.record_version!(Current.user)
      redirect_to @post, notice: "Post saved."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted."
  end

  private

    def set_post
      @post = Post.find_by(slug: params[:slug])
      render_not_found if @post.blank?
    end

    def render_not_found
      render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
    end

    def post_params
      params.require(:post).permit(:title, :summary, :content, :comments_enabled, author_ids: [])
    end

    # Whoever creates/edits/publishes a post is credited as an author,
    # alongside whichever authors were explicitly chosen in the form.
    def ensure_current_user_credited
      @post.author_ids = (@post.author_ids + [ Current.user.id ]).uniq
    end

    def apply_publish_state
      case params.dig(:post, :state)
      when "published"
        @post.published_at ||= Time.current
      when "draft"
        @post.published_at = nil
      end
    end
end
