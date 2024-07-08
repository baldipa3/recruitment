FactoryBot.define do
  factory :review do
    product
    body { "A review" }
    rating { rand(1..5) }
    reviewer_name { "John Doe" }
    tags { ["tag_1", "tag_2"] }
  end
end