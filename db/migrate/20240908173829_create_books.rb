class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :genre, array: true
      t.string :isbn, null: false
      t.integer :total_copies

      t.timestamps
    end
  end
end


#title, author, genre, ISBN, and total copies