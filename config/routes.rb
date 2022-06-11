Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'admin#index'

  get '/merchants/:merchant_id/dashboard', to: 'merchants#show'

  resources :admin, only: [:index]

  scope '/admin' do
    resources :merchants, controller: 'admin_merchants', except: %i[delete]
    resources :invoices, controller: 'admin_invoices', only: %i[index show update]
  end

  resources :merchants, only: [:show] do
    resources :items, controller: 'merchant_items'
    resources :invoices, controller: 'merchant_invoices', only: %i[index show update]
    resources :bulk_discounts, controller: 'merchant_bulk_discounts', only: %i[index show]
  end

  patch '/merchants/:merchant_id/items', to: 'merchant_items#update'

end
