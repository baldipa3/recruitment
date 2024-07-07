require 'rails_helper'

RSpec.describe RatingAnalyzer, type: :model do
  describe ".last_three_months_average_ratings" do
    let(:date) { Date.new(2024, 7, 15) }
    let(:analyzer) { RatingAnalyzer.new(date) }
    
    context "with ratings" do
      let!(:april) { FactoryBot.create_list(:review, 3, created_at: '2024-04-15') }
      let!(:may) { FactoryBot.create_list(:review, 3, created_at: '2024-05-15') }
      let!(:june) { FactoryBot.create_list(:review, 3, created_at: '2024-06-15') }
      let(:expected_average_ratings) do
        {
          "April 2024"=> (april.sum(&:rating) / 3).round(1),
          "June 2024"=> (june.sum(&:rating) / 3).round(1),
          "May 2024"=> (may.sum(&:rating) / 3).round(1)
        }
      end

      it 'calculates the average ratings for the last three months' do
        expect(analyzer.last_three_months_average_ratings).to eq(expected_average_ratings)
      end
    end

    context "without ratings" do
      let(:expected_average_ratings) { {} }

      it 'returns an empty has when no ratings' do
        expect(analyzer.last_three_months_average_ratings).to eq(expected_average_ratings)
      end
    end
  end
end