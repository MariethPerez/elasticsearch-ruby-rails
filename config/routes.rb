Rails.application.routes.draw do
  # get 'posts/index'
  # get 'posts/show'
  # get 'posts/new'
  # get 'posts/edit'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'posts#index'

  resources :posts do
    collection do
      get :search
    end
  end
end
