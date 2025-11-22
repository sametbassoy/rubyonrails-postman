Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#hello"
  get "hello", to: "pages#hello"

  namespace :api do
    namespace :v1 do
      post "auth/signup", to: "auth#signup"
      post "auth/login", to: "auth#login"
      get "auth/verify", to: "auth#verify"

      resources :users
      resources :posts
      resources :comments
      resources :courses
      resources :videos
      resources :subjects
      resources :analyses
      resources :reports
    end
  end
end
