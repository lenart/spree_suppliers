Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :suppliers

    resources :reports, only: [:index, :show] do
      get 'suppliers_orders', on: :collection
    end
  end


  # Add your extension routes here
end
