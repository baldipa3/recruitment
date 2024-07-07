class Review < ApplicationRecord
  belongs_to :product

  validates :body, :rating, :reviewer_name, presence: true
end
