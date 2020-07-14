Rails.application.routes.draw do
  get     "login"    => "sessions#new"
  post    "login"    => "sessions#create"
  delete     "logout"   => "sessions#destroy"
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
      resources :company_like_reviews
      resources :company_dislike_reviews
    end

    resources :company_interviews do
      resources :company_reply_interviews
    end

    resources :company_jobs do
      resources :company_apply_jobs
    end
  end

  get '/company_reply_reviews/new/(:company_id, :company_review_id)', to: 'company_reply_reviews#new', as: :new_company_reply_review

  get '/company_reply_interviews/new/(:company_id, :company_interview_id)', to: 'company_reply_interviews#new', as: :new_company_reply_interview

  get '/company_apply_jobs/new/(:company_id, :company_job_id)', to: 'company_apply_jobs#new', as: :new_company_apply_job

  resources :problems do
    resources :problem_solutions do
      resources :problem_reply_solutions
    end
  end

  get '/problem_reply_solutions/new/(:problem_id, :problem_solution_id)', to: 'problem_reply_solutions#new', as: :new_problem_reply_solution

  # New post
  get 'posts/new' => 'posts#new'

  # list các posts
  get 'posts' => 'posts#index'

  resources :posts do
    resources :post_comments do
      resources :post_reply_comments
    end
  end

  get '/post_reply_comments/new/(:post_id, :post_comment_id)', to: 'post_reply_comments#new', as: :new_post_reply_comment

  root "pages#index"
end
