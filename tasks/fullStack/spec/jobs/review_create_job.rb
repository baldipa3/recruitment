require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ReviewCreateJob, type: :job do
  describe "#perform" do
    let(:product) { FactoryBot.create(:product) }
    let(:body) { "Awesome video card" }
    let(:review_attrs) do
      {
        product_id: product.id,
        body: body,
        rating: 5.0,
        reviewer_name: "Jhon Doe"
      }
    end
    let(:tags) { ["first_tag", "second_tag"] }
    subject(:perform) { ReviewCreateJob.new.perform(review_attrs, tags) }

    it "creates a Review" do
      perform
      
      expect(Review.count).to eq(1)
    end

    context "when a required attr is not present" do
      let(:body) { nil }

      it "does nothing" do
        perform

        expect(Review.count).to eq(0)
      end
    end
  end
end