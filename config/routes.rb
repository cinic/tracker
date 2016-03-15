Toplast::Application.routes.draw do
  match '/delayed_job' => DelayedJobWeb, :anchor => false, via: [:get, :post]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource :packets, only: [:create]
      resources :devices
      get 'devices/:id/states', to: 'devices#states', as: 'device_states'
      get 'devices/:id/modes', to: 'devices#modes', as: 'device_modes'
      get 'devices/:id/modes/mini', to: 'devices#modes_mini', as: 'device_modes_mini'
      get 'devices/:id/perfomance', to: 'devices#perfomance', as: 'device_perfomance'
      get 'devices/:id/perfomance/mini', to: 'devices#perfomance_mini', as: 'device_perfomance_mini'
      get 'devices/:id/times/mini', to: 'devices#times_mini', as: 'device_times_mini'
      get 'devices/:id/consumption/mini', to: 'devices#consumption_mini', as: 'device_consumption_mini'
      get 'devices/:id/summary_table', to: 'devices#summary_table', as: 'device_summary_table'
    end
    post 'device_data', to: 'v1/packets#create'
  end

  namespace :admin, path: '/' do
    constraints subdomain: 'god' do
      get 'login', to: 'sessions#new', as: 'login'
      get 'logout', to: 'sessions#destroy', as: 'logout'
      post 'login', to: 'sessions#create', as: 'new_session'

      resources :admins
      resources :users, only: [:index, :show, :edit, :update]
      get '/devices/:id/refill_data', to: 'devices#refill_data', as: 'device_refill_data'
      get '/devices/:id/duplicated_clamps', to: 'devices#duplicated_clamps', as: 'device_duplicated_clamps'
      get '/devices/:id/bad_clamps', to: 'devices#bad_clamps', as: 'device_bad_clamps'
      get '/devices/:id/refill_clamps', to: 'devices#refill_clamps', as: 'device_refill_clamps'
      get '/devices/:id/refill_durations', to: 'devices#refill_durations', as: 'device_refill_durations'
      get '/devices/:id/refill_types', to: 'devices#refill_types', as: 'device_refill_types'
      get '/devices/:id/refill_pings', to: 'devices#refill_pings', as: 'device_refill_pings'
      get '/devices/:id/refill_states', to: 'devices#refill_states', as: 'device_refill_states'
      get '/devices/:id/check_packets', to: 'devices#check_packets', as: 'device_check_packets'
      get '/devices/:id/refilter_packets', to: 'devices#refilter_packets', as: 'device_refilter_packets'
      resources :devices, only: [:index, :show, :edit, :update]
      resources :packets, only: [:index, :destroy]
      resources :clamps, only: [:index]
      resources :states, only: [:index]
      resources :pings, only: [:index]
      resources :orders, only: [:index, :edit, :update]
      resources :tickets, only: [:index, :show, :edit, :update]
      root 'dashboard#show'
    end
  end

  scope '(:locale)', locale: /en/ do
    devise_for :users, path: '/', path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      password: 'password_resets',
      confirmation: 'confirm',
      unlock: 'unblock',
      registration: '/',
      sign_up: 'registration'
    }
    resource :user, only: [:edit, :update]
    get 'devices/:id/modes', to: 'devices#modes', as: 'device_modes'
    get 'devices/:id/perfomance', to: 'devices#perfomance', as: 'device_perfomance'
    get 'devices/:id/times', to: 'devices#times', as: 'device_times'
    get 'devices/:id/material-consumption', to: 'devices#material_consumption', as: 'device_material_consumption'
    get 'devices/:id/states', to: 'devices#states', as: 'device_states'
    resources :devices
    resources :tickets
    resource :order, only: [:new, :create]
    root to: 'pages#about'
  end
end
