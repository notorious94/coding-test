Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }

  mount API::Base => '/'
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      namespace :auth do
        post '/authenticate', to: 'authentication#authenticate'
        delete '/logout', to: 'authentication#logout'
      end
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
