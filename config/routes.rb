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
  
  # CRUD completo de facturas con acciones especiales
  resources :invoices do
    member do
      patch :mark_as_paid
      patch :cancel
    end
  end
  
  # CRUD básico de tipos de impuestos
  resources :tax_types do
    member do
      patch :toggle_status
    end
  end
end