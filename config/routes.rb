Rails.application.routes.draw do
  get "home/index"
  root to: "home#index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "devise/sessions",
    passwords: "devise/passwords"
  }

  namespace :admin do
    get "dashboard/index"
    resources :doctors, :departments, :availabilities
    resources :rooms do
      collection do
        get :utilization_report, defaults: { format: "csv" }
        post :import
      end
    end
    resources :beds do
      collection do
        post :import
      end
    end
    resources :departments do
      collection do
        post :import
      end
    end
    resources :doctors do
      collection do
        get :utilization_doctors_report, defaults: { format: "csv" }
        get "download_all_doctors_record", to: "doctors#download_all_doctors_record", defaults: { format: "pdf" }
      end
    end
    resources :rooms
    get "dashboard", to: "dashboard#index"
  end
    namespace :doctors do
  resources :patients do
    resources :medical_records, only: [ :new, :create ] do
      member do
        get "download", to: "medical_records#download"
      end
    end
  end
end

  resources :doctors do
    resources :appointments, only: [ :index, :show, :new, :create ]
  end

  resources :patients do
    resources :rooms
    get "dashboard", on: :member
    resources :appointments, only: [ :index, :new, :create ]
  resources :appointments do
    member do
      patch "cancel"
    end
  end
    resources :medical_records, only: [ :index, :show ]
    member do
    get "download_medical_record", to: "patients#download_medical_record", defaults: { format: "pdf" }
  end
  resources :admissions, only: [ :new, :create ]
  resources :admissions do
  member do
    patch :discharge
  end
end
  end

  get "doctor_dashboard", to: "doctors#dashboard", as: "doctor_dashboard"
  get "patient_dashboard", to: "patients#dashboard", as: "patient_dashboard"

  resources :profiles, only: [ :edit, :update ]

  get "rooms/usage_report", to: "rooms#usage_report", as: "room_usage_report"
end
