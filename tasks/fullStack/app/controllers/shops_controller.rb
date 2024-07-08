class ShopsController < ApplicationController
  def index
    @shops = Shop.all

    respond_to do |format|
      format.json { render json: @shops }
    end
  end
end