Rails.application.routes.draw do

   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # get "up" => "rails/health#show", as: :rails_health_check

  # get "/blog_posts/new", to: "blog_posts#new", as: :new_blog_post
  # post "/blog_posts", to: "blog_posts#create", as: :blog_posts

  # get "/blog_posts/:id", to: "blog_posts#show", as: :blog_post
 
  # get "/blog_posts/:id/edit", to: "blog_posts#edit", as: :edit_blog_post
  # patch "/blog_posts/:id", to: "blog_posts#update"

  # delete "/blog_posts/:id", to: "blog_posts#destroy"
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root 'blog_posts#home', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  
  resources :blog_posts do
    resource :cover_image, only: [:destroy], module: :blog_posts
 end

 
  get 'published_blog_posts', to: 'blog_posts#index', scope: 'published', as: :published_blog_posts
  get 'scheduled_blog_posts', to: 'blog_posts#index', scope: 'scheduled', as: :scheduled_blog_posts
  get 'draft_blog_posts', to: 'blog_posts#index', scope: 'draft', as: :draft_blog_posts
  get 'home', to: 'blog_posts#home', as: :home


end
