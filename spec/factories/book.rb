FactoryBot.define do
  factory :book do
    title { "The Hitchhiker's Guide to the Galaxy" }
    author  { "Douglas Adams" }
    genre {  ['Cience Fiction', 'Romance'] }
    isbn { "12345678" }
    total_copies { 10 }
  end
end