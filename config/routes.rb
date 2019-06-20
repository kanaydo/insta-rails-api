Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users do
        member do
          get :following, :followers
          post :follow
          get :posts
        end
      end
      resources :posts do
        collection do
          get :feed
        end
        member do
          post :comment
        end
      end
      resources :comments, only: [:create, :destroy]
    end
  end

end
