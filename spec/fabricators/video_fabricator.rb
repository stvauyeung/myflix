Fabricator(:video) do
  title { Faker::Lorem.words }
  description { Faker::Lorem.sentence }
end