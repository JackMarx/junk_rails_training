class StaffPicksController < ApplicationController
  def index
    vote_counts = Vote.group(:book_id).order("count_all DESC").limit(10).count

    book_ids = vote_counts.keys
    books_by_id = Book.where(id: book_ids).index_by(&:id)

    counts = vote_counts.values
    max_votes = counts.max.to_f
    mean_votes = counts.sum.to_f / [ counts.size, 1 ].max
    mean_stars = max_votes > 0 ? (mean_votes / max_votes) * 5.0 : 2.5

    @books_with_stars = vote_counts.filter_map do |book_id, count|
      book = books_by_id[book_id]
      next unless book
      [ book, Book.bayesian_stars(count, mean_stars) ]
    end

    token = cookies[:voter_token]
    @voted_book_ids = if token.present?
      Vote.where("session_token = ? OR ip_address = ?", token, request.remote_ip)
          .where(book_id: book_ids)
          .pluck(:book_id).to_set
    else
      Set.new
    end
  end
end
