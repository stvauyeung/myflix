class CreateCategorizationsTable < ActiveRecord::Migration
  def change
    create_table :categorizations do |t|
      t.references :video
      t.references :category
    end
  end
end
