FactoryGirl.define do
  factory :rule, class: Tokite::Rule do
    user
    sequence(:name) {|n| "name_#{n}" }
    query "query"
    channel "#general"
  end
end
