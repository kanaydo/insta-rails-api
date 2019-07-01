Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          get :following, :followers
          post :follow
          get :posts
          get :check_relation
        end
      end
      resources :posts do
        collection do
          get :feed
          get :explore
        end
        member do
          post :comment
        end
      end
      resources :comments, only: [:create, :destroy]
      resources :sessions, only: [:create, :destroy]
    end
  end

end
