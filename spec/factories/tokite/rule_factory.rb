FactoryBot.define do
  factory :rule, class: Tokite::Rule do
    association :user, strategy: :create
    sequence(:name) {|n| "name_#{n}" }
    query { "query" }
    channel { "#general" }
  end
end
