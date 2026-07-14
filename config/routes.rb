Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "cards#index"
  get "/my", controller: "cards", action: :my

  get "/card/:card_id", controller: "cards", action: :show
  get "/card/:card_id/edit", controller: "cards", action: :edit
  post "/card/:card_id/edit", controller: "cards", action: :change

  get "/card/:card_id/fields", controller: "fields", action: :get_all
  put "/card/:card_id/fields", controller: "fields", action: :new
  patch "/card/:card_id/fields/:field_id", controller: "fields", action: :edit
  delete "/card/:card_id/fields/:field_id", controller: "fields", action: :delete

  get "/new", controller: "cards", action: :new
  post "/new", controller: "cards", action: :create


  get "/login", controller: "sessions", action: :login
  post "/login", controller: "sessions", action: :create
  get "/whoami", controller: "sessions", action: :whoami
  post "/logout", controller: "sessions", action: :logout
end
