Rails.application.routes.draw do
  get 'data/shop'
  get 'data/texts'
  get 'data/terms_and_conditions'
  get 'data/privacy_policy'
  get 'data/profile_buttons'
  get 'data/marquesine'
  
  post 'notifications/mercadopago'

  resources :app_configs, except: [:new, :edit]
  resources :posts, except: [:new, :edit] do
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  resources :reviews, except: [:new, :edit] do
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  resources :ads, except: [:new, :edit] do
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  resources :plan_groups, except: [:new, :edit]
  resources :comments, except: [:new, :edit] do
    collection do
      put '/', action: :update_many
    end
  end
  resources :payments, except: [:new, :edit] do
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  resources :users, except: [:new, :edit] do
    resources :subscriptions, only: [:index, :destroy]
    member do
      get 'cards', action: :cards
    end
    collection do
      post 'push', action: :push
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  resources :invoices, except: [:new, :edit]
  resources :subscriptions, except: [:new, :edit] do
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  resources :plans, except: [:new, :edit]
  resources :promotions, except: [:new, :edit]
  resources :products, except: [:new, :edit] do
    resources :promotions, only: [:index, :destroy]
    resources :images, only: [:create, :update, :destroy]
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  resources :images, except: [:new, :edit]
  resources :sheds, except: [:new, :edit]
  resources :shop_claims, except: [:new, :edit] do
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
  end
  resources :shops, except: [:new, :edit] do
    collection do
      post '/create_and_claim', action: :create_and_claim
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
    member do
      post '/claim', action: :claim
      delete '/claim/:shop_claim_id', action: :destroy_claim
    end
  end
  resources :categories, except: [:new, :edit] do
    collection do
      put '/many', action: :update_many
      delete '/many', action: :destroy_many
    end
    member do
      put 'assign_to_shops', action: :assign_to_shops
      put 'assign_to_products', action: :assign_to_products
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
