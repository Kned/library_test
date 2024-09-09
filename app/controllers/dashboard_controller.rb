class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.librarian?
      @books = Book.all.sum(:total_copies)
      @borrowed_books = BorrowedBook.borrowed.count
      @books_due_today = BorrowedBook.borrowed.includes(:user).where(due_date: Date.today)
      @members = @books_due_today.map { |book| book.user }.uniq
    else
      @borrowed_books = @current_user.borrowed_books.includes(:book).borrowed
      @overdue_books = @current_user.borrowed_books.where("due_date < ?", Date.today)
    end
  end
  def books_to_deliver
    @borrowed_books = BorrowedBook.where("due_date <= ?", Date.today)
  end
end
