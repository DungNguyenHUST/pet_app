Rails.application.routes.draw do
  get     "login"    => "sessions#new"
  post    "login"    => "sessions#create"
  get     "logout"   => "sessions#destroy"
  get 'sessions/new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  resources :pages

  resources :posts do
    resources :comments
  end

  resources :companies do
    resources :company_reviews
    resources :company_interviews
  end

  resources :problems do
    resources :problem_solutions
  end

  # New post
  get 'posts/new' => 'posts#new'

  # list các posts
  get 'posts' => 'posts#index'

  # show single post
  # get 'post/post' => 'posts#show'

  root "pages#index"
end
