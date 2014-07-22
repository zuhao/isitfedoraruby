Isitfedoraruby::Application.routes.draw do

  root to: 'home#show'

  get 'contribute', to: 'static_pages#contribute'
  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'

  get 'searches/suggest_gems' => 'searches#suggest_gems'
  post 'searches/' => 'searches#redirect'
  get 'searches/:id' => 'searches#index'

  resources :fedorarpms, only: [:index, :show] do
    member do
      get :full_deps
      get :full_dependencies
      get :full_dependents
      get :by_owner
      get :badge
      get :not_found
    end
  end

  resources :rubygems, only: [:index, :show]

  resources :stats, only: [:index] do
    get :gemfile_tool, on: :collection
    get :user_rpms
    get :timeline
    get :tljson
    get :user_rpms_data
    post :gemfile_tool, on: :collection
  end

  # unless Rails.application.config.consider_all_requests_local
  get '*not_found', to: 'errors#error_404'
  #  end

end
