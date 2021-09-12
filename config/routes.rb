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
  
  resources :users do
    resources :user_notifications
  end

  resources :employers
  get 'employer_wellcome' => 'employers#wellcome'

  resources :admins

  resources :pages

  resources :companies do
    resources :company_reviews
    resources :company_interviews
    resources :company_questions
    resources :company_salaries
    resources :company_follows
	  resources :company_images
  end
  
  resources :company_reviews do
    resources :company_reply_reviews
    resources :company_react_reviews
  end
  
  resources :company_interviews do
    resources :company_reply_interviews
    resources :company_react_interviews
  end

  resources :company_jobs do
    resources :company_apply_jobs
    resources :company_save_jobs
  end

  resources :company_questions do
    resources :company_reply_questions
  end
  
  get 'jobs' => 'company_jobs#list'
  get 'jobs_search' => 'company_jobs#search'
  
  resources :problems do
    resources :problem_solutions
  end

  resources :problem_solutions do
    resources :problem_reply_solutions
    resources :problem_react_solutions
  end

  resources :posts do
    resources :post_comments
  end

  resources :post_comments do
    resources :post_reply_comments
  end

  resources :scrap_jobs
  get 'jobs_push' => 'scrap_jobs#push'

  resources :scrap_reviews

  resources :reports

  resources :cover_vitaes
  get 'cv_render_docx' => 'cover_vitaes#render_docx'
  get 'set_primary_cover_viate' => 'cover_vitaes#primary'

  get "search/index"

  get 'pages_select_company' => 'pages#select_company'

  root "pages#home"
end
