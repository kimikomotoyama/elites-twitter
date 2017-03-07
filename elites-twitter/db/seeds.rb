20.times do |index|
  Faker::Config.locale = :ja
  text = Faker::Lorem.sentence
  
  Tweet.create(user_id: 7, content: text)
end