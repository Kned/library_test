class BookController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: %i[show destroy edit update borrow]

  def index
    @books = Book.all
  end
  def show;end

  def edit;end

  def create
    @book = Book.new
    @book.assign_attributes(book_params)
    @book.genre = params[:book][:join_genres].split(",")
    if @book.save!
      flash[:notice] = "Book created"
      redirect_to book_path(id: @book.id)
    else
      flash[:alert] = "Book was not created"
    end
  end

  def update
    @book.assign_attributes(book_params)
    @book.genre = params[:book][:join_genres].split(",")
    if @book.save!
      flash[:notice] = "Book updated"
      redirect_to book_path(id: @book.id)
    else
      flash[:alert] = "Book was not updated"
    end
  end


  def destroy
    if @book&.destroy!
      flash[:notice] = "Book removed"
      redirect_to book_index_path
    end 
  rescue
    flash[:alert] = "Book was not removed"
  end

  def return_book
    borrowed_book = BorrowedBook.find(params[:borrow_id])
    if borrowed_book.update!(status: "returned")
      flash[:notice] = "Book returned"
      redirect_to root_path
    end
  rescue
    flash[:alert] = "Book was not returned"
  end

  def borrow
    if BorrowedBook.create!(user: current_user, book: @book)
      flash[:notice] = "Book borrowed"
      redirect_to book_index_path
    end
    rescue
      flash[:alert] = "Book was not borrowed"
      redirect_to book_index_path
  
  end
  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :isbn, :total_copies)
  end
end
