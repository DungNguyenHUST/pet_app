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
    resources :company_reviews do
      resources :company_reply_reviews
    end
    resources :company_interviews do
      resources :company_reply_interviews
    end
  end

  get '/company_reply_reviews/new/(:company_id, :company_review_id)', to: 'company_reply_reviews#new', as: :new_company_reply_review

  get '/company_reply_interviews/new/(:company_id, :company_interview_id)', to: 'company_reply_interviews#new', as: :new_company_reply_interview

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
