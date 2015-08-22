Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  resources :subs do
    resources :posts, only: :new
  end
  resources :posts, except: [:index, :new] do
    resources :comments, only: :new
  end

  resources :comments, except: [:new]
end
