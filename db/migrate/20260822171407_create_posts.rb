class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :summary, null: false
      t.datetime :published_at
      t.boolean :comments_enabled, null: false, default: true

      t.timestamps
    end
    add_index :posts, :slug, unique: true
  end
end
