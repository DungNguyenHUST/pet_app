Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations',
    passwords: 'admins/passwords'
  }
  
  devise_for :employers, controllers: {
    sessions: 'employers/sessions',
    registrations: 'employers/registrations',
    passwords: 'employers/passwords'
  }

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'
  
  resources :users do
    resources :user_notifications
  end

  resources :employers

  resources :admins

  resources :pages
  get "admin_search"   => "pages#index"

  resources :posts do
    resources :comments
  end

  resources :companies do
    resources :company_reviews
    resources :company_interviews
    resources :company_jobs

    resources :company_questions do
      resources :company_reply_questions
    end

    resources :company_salaries

    resources :company_follows
	
	  resources :company_images
  end
  
  resources :company_reviews do
    resources :company_reply_reviews
    resources :company_like_reviews
    resources :company_dislike_reviews
  end
  
  resources :company_interviews do
    resources :company_reply_interviews
    resources :company_like_interviews
    resources :company_dislike_interviews
  end

  resources :company_jobs do
    resources :company_apply_jobs
    resources :company_save_jobs
  end
  
  get 'company_job_list' => 'company_jobs#list'

  get '/company_reply_questions/new/(:company_id, :company_question_id)', to: 'company_reply_questions#new', as: :new_company_reply_question
  
  resources :problems do
    resources :problem_solutions do
      resources :problem_reply_solutions
      resources :problem_vote_solutions
      resources :problem_unvote_solutions
    end
  end

  get '/problem_reply_solutions/new/(:problem_id, :problem_solution_id)', to: 'problem_reply_solutions#new', as: :new_problem_reply_solution

  # New post
  get 'posts/new' => 'posts#new'

  # list posts
  get 'posts' => 'posts#index'

  resources :posts do
    resources :post_comments do
      resources :post_reply_comments
    end
  end

  resources :scrap_jobs

  resources :reports

  get '/post_reply_comments/new/(:post_id, :post_comment_id)', to: 'post_reply_comments#new', as: :new_post_reply_comment

  get "search/index"

  get 'pages_select_company' => 'pages#select_company'

  root "pages#home"
end
