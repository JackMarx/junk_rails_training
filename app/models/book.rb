class Book < ApplicationRecord
  has_many :votes, dependent: :destroy

  validates :title, presence: true
  validates :author, presence: true

  BAYESIAN_C = 5.0

  def voted_by?(ip:, token:)
    votes.exists?([ "ip_address = ? OR session_token = ?", ip, token ])
  end

  # Returns a Bayesian-smoothed star rating (0.0–5.0).
  # Returns 0.0 when there is no meaningful data (zero votes and zero mean).
  def self.bayesian_stars(vote_count, mean_stars)
    raw = (BAYESIAN_C * mean_stars + vote_count * 5.0) / (BAYESIAN_C + vote_count)
    [ raw, 0.0 ].max
  end
end
