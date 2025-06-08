Rails.application.routes.draw do
  devise_for :users,
             defaults: { format: :json },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations',
               confirmations: 'users/confirmations'
             }

  namespace :api do
    namespace :v1 do
      get 'users/current', to: 'users#current'
      resources :clients
    end
  end

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
  
end
