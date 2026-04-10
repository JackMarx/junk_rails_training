class BooksController < ApplicationController
  def index
    @books = Book.all.order(:title)
    token = cookies[:voter_token]
    @voted_book_ids = if token.present?
      Vote.where("session_token = ? OR ip_address = ?", token, request.remote_ip)
          .where(book_id: @books.map(&:id))
          .pluck(:book_id).to_set
    else
      Set.new
    end
  end

  def show
    @book = Book.find(params[:id])
    token = cookies[:voter_token]
    @voted = token.present? && Vote.exists?(
      [ "(session_token = ? OR ip_address = ?) AND book_id = ?",
        token, request.remote_ip, @book.id ]
    )
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: "Book was successfully deleted."
  end

  private

  def book_params
    params.expect(book: [ :title, :author, :published_on, :cost ])
  end
end
