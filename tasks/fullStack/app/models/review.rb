class Review < ApplicationRecord
  belongs_to :product

  validates :body, :rating, :reviewer_name, presence: true

  paginates_per 3
end
