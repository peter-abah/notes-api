Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  #
  devise_for(
    :users,
    defaults: { format: :json },
    path: 'api/v1',
    path_names: {
      sign_in: 'sign_in',
      sign_out: 'sign_out',
      registration: 'sign_up'
    },
    controllers: {
      sessions: 'api/v1/sessions',
      registrations: 'api/v1/registrations'
    }
  )

  namespace :api do
    namespace :v1 do
      resources :notes, except: %i[edit new]
      resources :collections, except: %i[edit new] do
        resources :notes, only: %i[index]
      end
    end
  end
end
