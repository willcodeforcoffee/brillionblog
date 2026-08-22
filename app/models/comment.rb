class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true

  validates :body, presence: true
  validates :guest_name, presence: true, if: -> { user.blank? }
  validates :guest_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { user.blank? }

  def author_name
    user&.name || guest_name
  end
end
