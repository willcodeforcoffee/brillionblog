class Post < ApplicationRecord
  has_rich_text :content

  has_many :post_authors, dependent: :destroy
  has_many :authors, through: :post_authors, source: :user
  has_many :post_versions, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :comments, -> { order(created_at: :asc) }, dependent: :destroy

  validates :title, presence: true
  validates :summary, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :authors, presence: true

  before_validation :generate_slug, on: :create

  scope :published, -> { where.not(published_at: nil).where(published_at: ..Time.current) }
  scope :drafts, -> { where(published_at: nil) }
  scope :recent_first, -> { order(published_at: :desc, created_at: :desc) }

  def published?
    published_at.present? && published_at <= Time.current
  end

  def draft?
    !published?
  end

  # Backs the draft/publish radio buttons on the post form.
  def state
    published? ? "published" : "draft"
  end

  def to_param
    slug
  end

  def comments_allowed?
    comments_enabled? && Setting.instance.comments_enabled?
  end

  # Snapshots the post's current state as a new version, crediting whoever
  # made the change (create/edit/publish) as an author of the post.
  def record_version!(editor)
    transaction do
      post_versions.create!(
        user: editor,
        title: title,
        summary: summary,
        content: content.to_s,
        published_at: published_at
      )
      authors << editor unless authors.include?(editor)
    end
  end

  private

    def generate_slug
      return if title.blank?

      base = title.parameterize
      candidate = base
      suffix = 2
      while Post.exists?(slug: candidate)
        candidate = "#{base}-#{suffix}"
        suffix += 1
      end
      self.slug = candidate
    end
end
