class AddAuthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    User.all.each do |user|
    	user.auth_token = SecureRandom.urlsafe_base64
    	user.save
    end
  end
end
