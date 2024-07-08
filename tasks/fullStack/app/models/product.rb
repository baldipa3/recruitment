class Product < ApplicationRecord
  belongs_to :shop
  has_many :reviews

  paginates_per 5
end
