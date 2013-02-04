Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :suppliers
  end


  # Add your extension routes here
end
