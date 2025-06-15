require "test_helper"

class ActivityPub::OutboxesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    user = users(:one)
    puts user_outbox_url(user.username)
    get user_outbox_url(user.username)
    assert_response :success
  end
end
