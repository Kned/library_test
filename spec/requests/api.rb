require 'rails_helper'
describe ::Api::V1::BooksController, type: :request do
  before do
    create(:user, api_token: "12345678", email: "admin@user.com")
  end
  describe "GET 'index'" do
    
    it "should be successful" do
      get '/api/v1/books', as: :json, headers: {:Authorization => "Token 12345678"}
      expect(response).to be_successful
    end
  end
  describe 'POST books/:id' do
    let(:book) { create(:book) }
    it "should be successful" do
      post "/api/v1/books/#{book.id}", as: :json, headers: {:Authorization => "Token 12345678"}, params: { title: "not a book"}
      expect(JSON.parse(response.body)["title"]).to eq("not a book")
      expect(response).to be_successful
    end
  end
  describe 'POST books' do
    let(:book_params) do
      {
        title: "some title",
        author: "some author",
        join_genres: "some genres",
        isbn: "123",
        total_copies: "3"
      }
    end
    it "should be successful" do
      post "/api/v1/books", as: :json, headers: {:Authorization => "Token 12345678"}, params: book_params
      expect(JSON.parse(response.body)["title"]).to eq("some title")
      expect(response).to be_successful
    end
  end
  describe 'POST books/:id/borrow' do
    let(:book) { create(:book) }
    it "should be successful" do
      post "/api/v1/books/#{book.id}/borrow", as: :json, headers: {:Authorization => "Token 12345678"}
      expect(JSON.parse(response.body)["status"]).to eq("borrowed")
      expect(response).to be_successful
    end
  end

  describe 'POST books/:id/return' do
    let(:borrowed_book) { create(:borrowed_book) }
    it "should be successful" do
      post "/api/v1/books/#{borrowed_book.id}/return", as: :json, headers: {:Authorization => "Token 12345678"}
      expect(JSON.parse(response.body)["status"]).to eq("returned")
      expect(response).to be_successful
    end
  end

  describe 'DELETE books/:id' do
    let(:book) { create(:book) }
    it "should be successful" do
      delete "/api/v1/books/#{book.id}", as: :json, headers: {:Authorization => "Token 12345678"}
      expect(response).to be_successful
      expect(JSON.parse(response.body)["message"]).to eq("Book removed")
    end
  end

end