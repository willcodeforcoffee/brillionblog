class CreatePostVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :post_versions do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :summary, null: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
