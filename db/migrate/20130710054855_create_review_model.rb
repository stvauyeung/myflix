class CreateReviewModel < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :video
      t.text :content
      t.timestamps
    end
  end
end
