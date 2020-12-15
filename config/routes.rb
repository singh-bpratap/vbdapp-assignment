Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :api, defaults: { format: :json } do
    scope :v1 do
      devise_for :users, :controllers => {registrations: 'api/v1/registrations'}
    end
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        resources :events
      end

      devise_scope :user do
        post "sign_in", to: "sessions#create"
      end
    end
  end
end
