Rails.application.routes.draw do
  resources :images
  root to: "welcome#index"
  devise_for :users, :controllers => {:registrations => "users"}
  mount ActionCable.server, at: '/cable'
end
