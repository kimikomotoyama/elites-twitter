FactoryGirl.define do
  factory :tweet do
    user_id 1
    reply_tweet_id 1
    content "MyString"
  end
end
