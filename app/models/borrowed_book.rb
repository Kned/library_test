class BorrowedBook < ApplicationRecord
  belongs_to :user
  belongs_to :book
  after_create :set_due_date
  validate :can_not_borrow_same_book, on: :create

  enum status: { borrowed: 0, returned: 1 }

  def set_due_date
    update(due_date: Date.today + 2.weeks) if due_date.blank?
  end

  def can_not_borrow_same_book
    if user.borrowed_books&.last&.book_id == book.id
      errors.add(:book_id, "can't be the same as the last book")
    end
  end

end
