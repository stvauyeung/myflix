Fabricator(:video) do
  title { Faker::Lorem.words(3) }
  description { Faker::Lorem.paragraph(2) }
end