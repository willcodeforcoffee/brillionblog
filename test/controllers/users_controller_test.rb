require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = users(:one)
    post session_url, params: { email_address: user.email_address, password: "password" }

    get users_url
    assert_response :success
  end

  test "should get show" do
    user = users(:one)
    get users_url(username: user.username)
    assert_response :success
  end
end
