Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      resources :users do

        member do
          get :following, :followers
          post :follow
        end

      end


      resources :posts

    end
  end

end
