class ReviewsController < ApplicationController
  protect_from_forgery except: :fetch_reviews


  DEFAULT_TAGS = ['default']

  def index
    @products = Product.where(shop_id: params[:shop_id]).page params[:page]
  end

  def fetch_reviews
    product = Product.includes(:reviews).find(params[:product_id])
    @reviews = product.reviews.order(created_at: :desc).page params[:page]

    respond_to do |format|
      format.js
    end
  end

  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
  end

  def create
    product = Product.find_by(id: review_params[:product_id])

    if product
      tags = tags_with_default(product)
      ReviewCreateJob.perform_later(review_params, tags)
      flash[:notice] = 'Review is being created in background. It might take a moment to show up'

      redirect_to reviews_path(shop_id: product.shop_id)
    else
      flash[:alert] = 'Product not found. Review creation failed.'

      redirect_to reviews_path
    end
  end

  private

  def tags_with_default(product)
    shop_tags = product.shop.tags || DEFAULT_TAGS
    review_tags = review_params[:tags]&.split(',') || []

    (shop_tags + review_tags).uniq
  end

  def review_params
    params.require(:review).permit(:product_id, :body, :rating, :reviewer_name, :tags).to_h
  end
end