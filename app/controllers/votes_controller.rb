class VotesController < ApplicationController
  before_action :set_book
  before_action :ensure_voter_token

  def create
    existing = @book.votes.find_by(
      "ip_address = ? OR session_token = ?",
      request.remote_ip,
      cookies[:voter_token]
    )

    if existing
      existing.destroy
    else
      @book.votes.create!(
        ip_address: request.remote_ip,
        session_token: cookies[:voter_token]
      )
    end

    redirect_back_or_to book_path(@book)
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def ensure_voter_token
    cookies.permanent[:voter_token] ||= SecureRandom.uuid
  end
end
