FactoryGirl.define do
  factory :rule do
    user
    sequence(:name) {|n| "name_#{n}" }
    pattern "pattern"
    channel "#general"
  end
end
