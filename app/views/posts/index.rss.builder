xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "BrillionBlog"
    xml.description "Posts from BrillionBlog"
    xml.link posts_url

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.summary
        xml.pubDate post.published_at.to_fs(:rfc822)
        xml.link post_url(post)
        xml.guid post_url(post)
        post.authors.each { |author| xml.author author.name }
      end
    end
  end
end
