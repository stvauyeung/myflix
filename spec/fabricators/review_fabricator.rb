Fabricator(:review) do
  content { Faker::Lorem.paragraph }
  rating { rand(1..5) }
end