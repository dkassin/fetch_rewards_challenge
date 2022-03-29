Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/users/add_transactions', to: 'users#add_transactions'
      post '/users/spend_points', to: 'users#spend_points'
      get '/users/points_balance', to: 'users#points_balance'
    end
  end
end
