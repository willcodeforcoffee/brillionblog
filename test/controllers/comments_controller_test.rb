require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "guests can comment with a name and email" do
    assert_difference "Comment.count", 1 do
      post post_comments_url(posts(:one)), params: {
        comment: { body: "Nice post!", guest_name: "Guest", guest_email: "guest@example.com" }
      }
    end

    assert_redirected_to post_url(posts(:one))
    assert_nil Comment.order(:created_at).last.user
  end

  test "signed-in users can comment without guest fields" do
    sign_in users(:one)

    assert_difference "Comment.count", 1 do
      post post_comments_url(posts(:one)), params: { comment: { body: "Nice post!" } }
    end

    assert_equal users(:one), Comment.order(:created_at).last.user
  end

  test "comments are rejected when disabled for the post" do
    assert_no_difference "Comment.count" do
      post post_comments_url(posts(:no_comments)), params: {
        comment: { body: "Nice post!", guest_name: "Guest", guest_email: "guest@example.com" }
      }
    end

    assert_redirected_to post_url(posts(:no_comments))
  end

  test "comments are rejected when disabled site-wide" do
    Setting.instance.update!(comments_enabled: false)

    assert_no_difference "Comment.count" do
      post post_comments_url(posts(:one)), params: {
        comment: { body: "Nice post!", guest_name: "Guest", guest_email: "guest@example.com" }
      }
    end
  end

  private

    def sign_in(user)
      post session_url, params: { email_address: user.email_address, password: "password" }
    end
end
