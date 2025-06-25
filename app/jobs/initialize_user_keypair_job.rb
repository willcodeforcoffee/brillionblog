class InitializeUserKeypairJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    unless user.public_key.blank? && user.private_key.blank?
      Rails.logger.error "User with ID #{user_id} already has a keypair or part of a keypair initialized. This will require manual intervention."
      return nil
    end

    keypair = OpenSSL::PKey::RSA.new(2048)
    user.private_key = keypair.to_pem
    user.public_key  = keypair.public_key.to_pem

    user.save!

    true

  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "User with ID #{user_id} not found for keypair initialization."
  end
end
