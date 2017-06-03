FactoryGirl.define do
  factory :rule do
    user
    sequence(:name) {|n| "name_#{n}" }
    pattern "pattern"
    channels "test-hogelog,general tech"
  end
end
