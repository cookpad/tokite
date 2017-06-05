FactoryGirl.define do
  factory :rule do
    user
    sequence(:name) {|n| "name_#{n}" }
    query "query"
    channel "#general"
  end
end
