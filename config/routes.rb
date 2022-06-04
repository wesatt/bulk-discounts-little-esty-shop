Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :customers, only: [:index]

  get '/merchants/:merchant_id/dashboard', to: 'merchants#show'
  # get '/merchants/:merchant_id/items', to: 'merchant_items#index'
  # get '/merchants/:merchant_id/invoices', to: 'merchant_invoices#index'
  resources :merchants, only: [:show] do
    resources :items, controller: 'merchant_items'
    resources :invoices, controller: 'merchant_invoices', only: %i[index show update]
  end
  patch '/merchants/:merchant_id/items', to: 'merchant_items#update'

    # resources :merchants


  resources :admin, only: [:index]
  scope :admin do
    resources :merchants, controller: 'admin_merchants', accept: [:delete, :put]
    resources :invoices, controller: 'admin_invoices', only: [:index]
  end
  # patch '/admin/merchants/:merchant_id', to: 'admin_merchants#update'
  # get '/admin/merchants/:merchant_id/edit', to: 'admin_merchants#edit'

end
