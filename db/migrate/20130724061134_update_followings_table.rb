class UpdateFollowingsTable < ActiveRecord::Migration
  def change
  	rename_column :followings, :following_id, :follower_id
  end
end
