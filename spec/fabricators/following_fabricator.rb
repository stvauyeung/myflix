Fabricator(:following) do
	user_id { Fabricate(:user).id }
	follower_id { Fabricate(:user).id }
end