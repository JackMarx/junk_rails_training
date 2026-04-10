Rails.application.routes.draw do
  root "staff_picks#index"

  resources :books, only: [ :index, :show, :new, :create, :destroy ] do
    resource :vote, only: [ :create ]
  end
end
