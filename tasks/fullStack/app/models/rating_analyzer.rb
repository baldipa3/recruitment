class RatingAnalyzer
  attr_reader :date

  def initialize(date)
    @date = date
  end

  def last_three_months_average_ratings
    reviews_per_month.each_with_object({}) do |review, hash|
      month_key = review.month.strftime("%B %Y")
      hash[month_key] = review.average_rating.to_f.round(1)
    end
  end

  private
  
  def reviews_per_month
    end_date = date.prev_month.end_of_month
    start_date = (end_date << 2).beginning_of_month

    Review.where(created_at: start_date..end_date)
      .select("DATE_TRUNC('month', created_at) as month, AVG(rating) as average_rating")
      .group("DATE_TRUNC('month', created_at)")
      .order("month DESC")
  end
end
