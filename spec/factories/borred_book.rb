FactoryBot.define do
  factory :borrowed_book do
    book { create(:book) }
    user { create(:user, email:"email@user#{rand(99)}.com" ) }
  end
end