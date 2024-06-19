Rails.application.routes.draw do
  apipie  
  namespace :api do
    namespace :v1 do
      resources :departments
      resources :employees
      resources :log_records
    end
  end
end
