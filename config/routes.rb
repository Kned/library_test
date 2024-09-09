Rails.application.routes.draw do
  devise_for :users

  resources :book
  
  get '/dashboard/books_to_deliver', to: "dashboard#books_to_deliver"
  post '/book/:borrow_id/return', to: 'book#return_book', as: 'book_return'
  post '/book/:id/borrow', to: 'book#borrow', as: 'book_borrow'
  root "dashboard#index"

  namespace "api" do
    namespace 'v1' do
      get 'books', to: "books#index"
      get 'books/:id', to: "books#show"
      post 'books/:id', to: "books#update"
      post 'books/:id/borrow', to: "books#borrow"
      post 'books', to: "books#create"
      post '/books/:borrow_id/return', to: 'books#return_book'
      delete 'books/:id', to: "books#destroy"
    end
  end
end
