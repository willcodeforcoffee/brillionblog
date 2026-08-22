class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :post_authors, dependent: :destroy
  has_many :posts, through: :post_authors
  has_many :post_versions, dependent: :destroy
  has_many :comments, dependent: :destroy

  after_create :initialize_keypair

  validates :email_address, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  private

  def initialize_keypair
    if public_key.blank? && private_key.blank?
      InitializeUserKeypairJob.perform_later(id)
    end
  end
end
