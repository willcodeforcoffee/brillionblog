class CreateSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :settings do |t|
      t.boolean :comments_enabled, null: false, default: true

      t.timestamps
    end
  end
end
