class AddQueuingPosition < ActiveRecord::Migration
  def change
    add_column :queuings, :position, :integer
  end
end
