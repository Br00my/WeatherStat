FactoryBot.define do
  factory :temperature do
    sequence(:time) { |n| n.hour.ago }
    value { rand(1..100) }
  end
end
