require 'rails_helper'

RSpec.describe ReviewsController, type: :request do
  describe "#create" do
    let(:product) { FactoryBot.create(:product) }
    let(:product_id) { product.id }
    let(:tags) { "first_tag,second_tag,third_tag" }
    let(:params) do
      {
        review: {
          product_id: product_id,
          body: "Awesome video card",
          rating: 5.0,
          reviewer_name: 'Jhon Doe',
          tags: tags
        }
      }
    end

    it "schedules a ReviewCreateJob" do
      expect { post '/reviews', params: params }.to have_enqueued_job(ReviewCreateJob)
    end


    context "review creation with and without tags" do
      before { allow(ReviewCreateJob).to receive(:perform_later) }

      context "with params[:tags]" do
        it "schedules ReviewCreatejob including the params tags" do
          post '/reviews', params: params
    
          expect(ReviewCreateJob).to have_received(:perform_later) do |review_params, tags|
            expect(tags).to include("first_tag", "second_tag", "third_tag")
          end
        end
      end
  
      context "without params[:tags]" do
        let(:tags) { nil }
  
        it "schedules ReviewCreatejob with the default tags" do
          post '/reviews', params: params
    
          expect(ReviewCreateJob).to have_received(:perform_later) do |review_params, tags|
            expect(tags).to eq(["default"])
          end
        end
      end
    end

    context "when product exist" do
      it "redirects to /reviews" do
        post '/reviews', params: params

        expect(response).to redirect_to(reviews_path(shop_id: product.shop_id))
      end
    end

    context "when product is not found" do
      let(:product_id) { product.id + 1 }

      it "redirects to /reviews" do
        post '/reviews', params: params

        expect(response).to redirect_to(reviews_path)
      end
    end
  end

  describe "#index" do
    let(:product) { FactoryBot.create(:product) }

    it 'renders the index template' do
      get "/reviews", params: { shop_id: product.shop_id }

      expect(response.status).to eq(200)
    end
  end

  describe "#fetch_reviews" do
    let(:product) { FactoryBot.create(:product) }
    let(:reviews) { create_list(:review, 10, product: product) }

    it 'renders the index template' do
      get "/reviews/fetch_reviews", params: { product_id: product.id }, xhr: true

      expect(response.status).to eq(200)
    end
  end
end