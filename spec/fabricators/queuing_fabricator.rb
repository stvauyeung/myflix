Fabricator(:queuing) do
  user_id { Fabricate(:user).id }
  video_id { Fabricate(:video).id }
end