require "test_helper"

class WellKnown::WebfingerControllerTest < ActionDispatch::IntegrationTest
  test "should get 400 Bad Request when no resource provided" do
    get webfinger_url
    assert_response :bad_request
  end

  test "should get 404 Not Found when user does not exist" do
    get webfinger_url, params: { resource: "acct:test@example.com" }
    assert_response :not_found
  end

  test "should get 200 OK with valid user" do
    user = users(:one) # Assuming you have a fixture for a valid user
    get webfinger_url, params: { resource: "acct:#{user.email_address}" }
    assert_response :ok

    json_response = JSON.parse(response.body)
    assert_equal "acct:#{user.email_address}", json_response["subject"]
    assert_includes json_response["links"], { "rel" => "self", "type" => "application/activity+json", "href" => root_url }
  end
end
