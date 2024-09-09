class Api::V1::BooksController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_book, only: %i[show destroy update borrow]
  before_action :authenticate

  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      User.find_by(api_token: token)
    rescue
      render status: :unauthorized, json: { error: "You are not authorized to access this resource. Verify that you are passing passing your token."}
    end
  end

  def current_user
    @current_user ||= authenticate
  end

  def index
    @books = Book.all
    render json: @books.to_json
  end
  def show
    render json: @book.to_json
  end

  def create
    @book = Book.new
    @book.assign_attributes(book_params)
    @book.genre = params[:join_genres].split(",") if params[:join_genres].present?
    if @book.save!
      render json: @book.to_json
    else
      render status: :unprocessable_entity, json: { error: @book.errors}
    end
  end

  def update
    @book.assign_attributes(book_params)
    @book.genre = params[:join_genres].split(",") if params[:join_genres].present?
    if @book.save!
      render json: @book.to_json
    else
      render status: :unprocessable_entity, json: { error: @book.errors}
    end
  end


  def destroy
    if @book&.destroy!
      render status: :ok, json: { message: "Book removed"}
    else
      render status: :unprocessable_entity, json: { error: @book.errors}
    end
  end

  def return_book
    borrowed_book = BorrowedBook.find(params[:borrow_id])
    if borrowed_book.update!(status: "returned")
      render json: borrowed_book.to_json
    else
      render status: :unprocessable_entity, json: { error: borrowed_book.errors}
    end
  end

  def borrow
    borrowed_book = BorrowedBook.create(user: current_user, book: @book)
    if borrowed_book.persisted?
      render json: borrowed_book.to_json
    else
      flash[:alert] = "Book was not borrowed"
      render status: :unprocessable_entity, json: { error: borrowed_book.errors}
    end
  end
  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.permit(:title, :author, :isbn, :total_copies)
  end

  
end
