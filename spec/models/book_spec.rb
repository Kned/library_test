# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'total_available' do
    
    context 'when dont have any borrowed books' do
      let(:book) { create(:book) }
      it 'return total books registered' do
        expect(
          book.total_available
        ).to eq(10)
      end
    end
    context 'when has a single book borrowed' do
      let(:borrowed_book) { create(:borrowed_book, book: create(:book, isbn: "12")) }
      it 'return total books registered less one' do
        expect(
          borrowed_book.book.total_available
        ).to eq(9)
      end
    end
  end
  describe "available" do
    context "when has a book available" do
      let(:book) { create(:book) }
      it 'return true' do
        expect(book.available?).to be_truthy
      end
    end
    context "when does not have a book available" do
      let(:book) { create(:book, total_copies: 0 ) }
      it "return false" do
        expect(book.available?).to be_falsy
      end
    end
  end
  describe "join_genres" do
    context "with multiple genres" do
      let(:book) { create(:book, genre: ["gen1", "gen2", "gen3"])}
      it "joins all genres" do
        expect(book.join_genres).to eq("gen1, gen2, gen3")
      end
    end
    context "with a single genre"  do
      let(:book) { create(:book, genre: ["gen1"])}
      it "return a single genre" do
        expect(book.join_genres).to eq("gen1")
      end
    end
  end
  describe "create" do
    context "with valid attributes" do
      let(:book_attributes) {{ title: "title", author: "Douglas Adams", genre: ["genres"], isbn: "12345671", total_copies: 10 }}
      it "create book" do
        expect{described_class.create(book_attributes)}.to change{Book.count}.by(1)
      end
    end
    context "with duplicated isbn" do
      let(:book_attributes) {{ title: "title", author: "Douglas Adams", genre: ["genres"], isbn: "12345671", total_copies: 10 }}
      before do
        described_class.create(book_attributes)
      end
      it "not create duplicate" do
        expect{described_class.create(book_attributes)}.not_to change{Book.count}
      end
    end
  end
end
