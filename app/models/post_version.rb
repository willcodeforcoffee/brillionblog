class PostVersion < ApplicationRecord
  has_rich_text :content

  belongs_to :post
  belongs_to :user

  default_scope { order(created_at: :desc) }
end
