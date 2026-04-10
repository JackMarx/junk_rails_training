class Vote < ApplicationRecord
  belongs_to :book

  validates :ip_address, presence: true
  validates :session_token, presence: true
  validates :session_token, uniqueness: { scope: :book_id }
end
