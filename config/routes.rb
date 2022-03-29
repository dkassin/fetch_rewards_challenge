Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/users/add_transactions', to: 'users#add_transactions'
      post '/users/spend_points', to: 'users#spend_points'
      # get '/users', to: 'payers#index'
      # get '/points_balance', to: 'points_balance#index'
    end
  end
end
