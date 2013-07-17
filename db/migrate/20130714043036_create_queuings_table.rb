class CreateQueuingsTable < ActiveRecord::Migration
  def change
    create_table :queuings do |t|
      t.references :video
      t.references :user
      t.timestamps
    end
  end
end
