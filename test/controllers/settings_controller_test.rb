require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  test "requires authentication" do
    get edit_settings_url
    assert_redirected_to new_session_url
  end

  test "signed-in users can toggle comments site-wide" do
    sign_in users(:one)

    patch settings_url, params: { setting: { comments_enabled: "0" } }
    assert_redirected_to edit_settings_url
    assert_not Setting.instance.comments_enabled?
  end

  private

    def sign_in(user)
      post session_url, params: { email_address: user.email_address, password: "password" }
    end
end
