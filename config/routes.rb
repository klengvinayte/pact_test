# frozen_string_literal: true

Rails.application.routes.draw do
  resources :skills
  resources :interests
  resources :users

  root 'users#index'
end
