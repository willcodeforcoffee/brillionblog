require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "generates a unique slug from the title on create" do
    post = Post.create!(title: "First Post", summary: "Summary", authors: [ users(:one) ])
    assert_equal "first-post-2", post.slug
  end

  test "published? is true only once published_at has passed" do
    assert posts(:one).published?
    assert_not posts(:draft_one).published?
  end

  test "record_version! snapshots the post and credits the editor as an author" do
    post = posts(:draft_one)
    editor = users(:two)

    assert_not post.authors.include?(editor)

    assert_difference -> { post.post_versions.count }, 1 do
      post.record_version!(editor)
    end

    assert_includes post.reload.authors, editor
    version = post.post_versions.first
    assert_equal editor, version.user
    assert_equal post.title, version.title
  end

  test "comments_allowed? respects both the per-post and site-wide settings" do
    assert posts(:one).comments_allowed?

    assert_not posts(:no_comments).comments_allowed?

    Setting.instance.update!(comments_enabled: false)
    assert_not posts(:one).comments_allowed?
  end
end
