Rails.application.routes.draw do
  resources :departments
  resources :employees
  resources :log_records
end