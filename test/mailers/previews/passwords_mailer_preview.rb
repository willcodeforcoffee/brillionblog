# Preview all emails at http://localhost:7790/rails/mailers/passwords_mailer
class PasswordsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:7790/rails/mailers/passwords_mailer/reset
  def reset
    PasswordsMailer.reset(User.take)
  end
end
