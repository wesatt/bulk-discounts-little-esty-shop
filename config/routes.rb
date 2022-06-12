Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'admin#index'

  get '/merchants/:id/dashboard', to: 'merchants#show'

  resources :merchants, only: %i[show] do
    resources :items, controller: 'merchant_items', except: %i[destroy]
    resources :invoices, controller: 'merchant_invoices', only: %i[index show update]
    resources :bulk_discounts, controller: 'merchant_bulk_discounts'
  end

  resources :admin, only: %i[index]

  scope '/admin' do
    resources :merchants, controller: 'admin_merchants', except: %i[destroy]
    resources :invoices, controller: 'admin_invoices', only: %i[index show update]
  end
end
