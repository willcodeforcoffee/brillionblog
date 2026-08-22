require "test_helper"

class Posts::VersionsControllerTest < ActionDispatch::IntegrationTest
  test "requires authentication" do
    get post_versions_url(posts(:one))
    assert_redirected_to new_session_url
  end

  test "signed-in users can see a post's version history and an individual snapshot" do
    sign_in users(:one)
    post_record = posts(:one)
    post_record.record_version!(users(:one))
    version = post_record.post_versions.first

    get post_versions_url(post_record)
    assert_response :success
    assert_match version.title, response.body

    get post_version_url(post_record, version)
    assert_response :success
  end

  private

    def sign_in(user)
      post session_url, params: { email_address: user.email_address, password: "password" }
    end
end
