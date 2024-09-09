class Book < ApplicationRecord
  has_many :borrowed_books, dependent: :destroy
  validates_uniqueness_of :isbn


  def total_available
    total_copies - borrowed_books.borrowed.count
  end

  def available?
    total_available >= 1
  end

  def join_genres
    genre.join(", ")
  end
end
