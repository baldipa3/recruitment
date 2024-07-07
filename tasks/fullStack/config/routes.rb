require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app

  resources :reviews, only: [:index, :create, :new] do
    get 'fetch_reviews', on: :collection
  end

  resources :shops, only: [:index]
end