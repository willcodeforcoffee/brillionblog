require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "guests only see published posts in the index" do
    get posts_url
    assert_response :success
    assert_match posts(:one).title, response.body
    assert_no_match posts(:draft_one).title, response.body
  end

  test "signed-in users see drafts in the index" do
    sign_in users(:one)

    get posts_url
    assert_response :success
    assert_match posts(:draft_one).title, response.body
  end

  test "guests can view a published post but not a draft" do
    get post_url(posts(:one))
    assert_response :success

    get post_url(posts(:draft_one))
    assert_response :missing
  end

  test "signed-in users can view a draft" do
    sign_in users(:one)

    get post_url(posts(:draft_one))
    assert_response :success
  end

  test "creating a post stamps a version and credits the author" do
    sign_in users(:one)

    assert_difference [ "Post.count", "PostVersion.count" ], 1 do
      post posts_url, params: {
        post: {
          title: "A New Post",
          summary: "Summary",
          content: "<div>Body</div>",
          comments_enabled: "1",
          state: "published"
        }
      }
    end

    created = Post.order(:created_at).last
    assert_redirected_to post_url(created)
    assert created.published?
    assert_includes created.authors, users(:one)
    assert_equal users(:one), created.post_versions.first.user
  end

  test "updating a post stamps another version" do
    sign_in users(:one)
    post_record = posts(:one)

    assert_difference -> { post_record.post_versions.count }, 1 do
      patch post_url(post_record), params: {
        post: { title: "Updated Title", summary: post_record.summary, state: "published" }
      }
    end

    assert_equal "Updated Title", post_record.reload.title
  end

  test "destroying a post removes it" do
    sign_in users(:one)
    post_record = posts(:one)

    assert_difference "Post.count", -1 do
      delete post_url(post_record)
    end
  end

  test "the rss feed only includes published posts and uses the summary" do
    get posts_url(format: :rss)
    assert_response :success
    assert_match posts(:one).summary, response.body
    assert_no_match posts(:draft_one).title, response.body
  end

  private

    def sign_in(user)
      post session_url, params: { email_address: user.email_address, password: "password" }
    end
end
