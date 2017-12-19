Rails.application.routes.draw do

  resources :plan_groups, except: [:new, :edit]
  get 'data/shop'
  get 'data/texts'
  get 'data/terms_and_conditions'
  
  post 'notifications/mercadopago'

  resources :comments, except: [:new, :edit] do
    collection do
      put '/', action: :update_many
    end
  end
  resources :payments, except: [:new, :edit]
  resources :users, except: [:new, :edit] do
    resources :subscriptions, only: [:index, :destroy]
    member do
      get 'cards', action: :cards
    end
  end
  resources :invoices, except: [:new, :edit]
  resources :subscriptions, except: [:new, :edit]
  resources :plans, except: [:new, :edit]
  resources :promotions, except: [:new, :edit]
  resources :products, except: [:new, :edit] do
    resources :promotions, only: [:index, :destroy]
  end
  resources :images, except: [:new, :edit]
  resources :sheds, except: [:new, :edit]
  resources :shops, except: [:new, :edit] do
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  resources :categories, except: [:new, :edit] do
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  resources :contacts, except: [:new, :edit] do
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  mount_devise_token_auth_for 'User', at: 'auth'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
