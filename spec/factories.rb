FactoryBot.define do
    factory :question do
      name { Faker::Lorem.sentence }
      description { Faker::Lorem.paragraph }
      user_id { create(:user).id }
    end
    factory :user do
        email { Faker::Internet.email }
        password {"password"}
        password_confirmation {"password"}
        username { "test" }
      end
  end