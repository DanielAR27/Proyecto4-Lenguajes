Rails.application.routes.draw do
  root "home#index"
  
  resources :products do
    collection do
      get :low_stock
    end
    member do
      patch :toggle_status
      get :stock_history
    end
  end
  
  # Solo index y new por ahora
  resources :invoices, only: [:index, :new, :create]
  
  # CRUD básico de tipos de impuestos
  resources :tax_types do
    member do
      patch :toggle_status
    end
  end
end