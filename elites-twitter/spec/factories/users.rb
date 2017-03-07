FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "test #{n}" }
    sequence(:email) { |n| "user#{n}@test2.com" }
    password "testtesttest"
    password_confirmation "testtesttest"
    image "profile_image.jpg"
    sequence(:profile) { |n| "profile #{n}" }
  end
end