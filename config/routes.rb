Rails.application.routes.draw do
  root "home#index"
  
  resources :products do
    collection do
      get :low_stock
    end
    member do
      patch :toggle_status
    end
  end
end