class ReviewCreateJob < ApplicationJob
  queue_as :default

  def perform(review_attrs, tags)
    product = Product.find(review_attrs[:product_id])

    Review.create(
      product: product,
      body: review_attrs[:body],
      rating: review_attrs[:rating],
      reviewer_name: review_attrs[:reviewer_name],
      tags: tags
    )
  end
end
