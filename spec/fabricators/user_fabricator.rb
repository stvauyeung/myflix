Fabricator(:user) do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  password { "password" }
  admin false
end

Fabricator(:admin, from: :user) do
	admin true
end