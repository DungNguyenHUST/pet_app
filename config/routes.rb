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
    resources :user_educations
    resources :user_experiences
    resources :user_skills
    resources :user_certificates
    resources :user_adwards
  end
  get 'user_profile' => 'users#profile'
  get 'user_preview' => 'users#preview'

  resources :employers do
    resources :employer_notifications
  end
  get 'employer_wellcome' => 'employers#wellcome'
  get 'employer_job' => 'employers#job'
  get 'employer_plan' => 'employers#plan'
  get 'employer_index_job' => 'employers#index_job'
  get 'employer_index_apply' => 'employers#index_apply'
  get 'employer_index_cv' => 'employers#index_cv'
  get 'employer_cv_search' => 'employers#cv_search'

  resources :admins

  resources :pages
  get 'about_us' => 'pages#about_us'
  get 'contact_us' => 'pages#contact_us'
  get 'our_product' => 'pages#our_product'
  get 'policy' => 'pages#policy'
  get 'term' => 'pages#term'

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
  get 'jobs_approve' => 'company_jobs#approve'
  get 'jobs_search' => 'company_jobs#search'

  resources :company_questions do
    resources :company_reply_questions
  end
  
  resources :problems do
    resources :problem_solutions
  end
  get 'problems_approve' => 'problems#approve'

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
  get 'scrap_jobs_push' => 'scrap_jobs#push'
  get 'scrap_jobs_processing' => 'scrap_jobs#processing'

  resources :scrap_reviews

  resources :reports

  resources :cover_vitaes
  get 'cv_render_docx' => 'cover_vitaes#render_docx'
  get 'set_primary_cover_viate' => 'cover_vitaes#primary'

  get "search/index"

  get 'pages_select_company' => 'pages#select_company'

  root "pages#home"
end
