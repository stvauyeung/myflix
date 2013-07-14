Fabricator(:queuing) do
  user_id { Fabricate(:user) }
  video_id { Fabricate(:video) }
end