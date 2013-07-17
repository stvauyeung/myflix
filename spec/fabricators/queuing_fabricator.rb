Fabricator(:queuing) do
  user { Fabricate(:user) }
  video { Fabricate(:video) }
end