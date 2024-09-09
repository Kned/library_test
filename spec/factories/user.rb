FactoryBot.define do
  factory :user do
    name { "Test User" }
    email  { "user@email.com" }
    password { '12345678' }
    api_token { "12345678" }
  end
end