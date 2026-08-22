require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "guest comments require a name and a valid email" do
    comment = Comment.new(post: posts(:one), body: "Nice!")
    assert_not comment.valid?
    assert_includes comment.errors.attribute_names, :guest_name
    assert_includes comment.errors.attribute_names, :guest_email

    comment.guest_name = "Guest"
    comment.guest_email = "not-an-email"
    assert_not comment.valid?
    assert_includes comment.errors.attribute_names, :guest_email

    comment.guest_email = "guest@example.com"
    assert comment.valid?
  end

  test "member comments don't require guest fields" do
    comment = Comment.new(post: posts(:one), user: users(:one), body: "Nice!")
    assert comment.valid?
  end

  test "author_name prefers the member's name over the guest name" do
    comment = comments(:one)
    assert_equal comment.user.name, comment.author_name

    guest_comment = comments(:guest_one)
    assert_equal guest_comment.guest_name, guest_comment.author_name
  end
end
