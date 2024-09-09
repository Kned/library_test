class CreateBorrowedBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :borrowed_books do |t|
      t.integer :status, default: 0
      t.references :user
      t.references :book
      t.date :due_date

      t.timestamps
    end
  end
end
