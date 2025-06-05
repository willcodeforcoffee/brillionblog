require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get show" do
    user = users(:one)
    get users_url(username: user.username)
    assert_response :success
  end
end
