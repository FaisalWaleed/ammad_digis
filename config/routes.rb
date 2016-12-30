Rails.application.routes.draw do
  namespace :stripe do
    post 'subscriptions/callback' => 'subscriptions#callback'
  end

  resources :admins
  
  post 'physician/prescription/set_drug' => 'physician/prescriptions#set_drug'
  patch 'physician/prescription/set_drug' => 'physician/prescriptions#set_drug'
  post 'physician/prescription/set_pharmacy' => 'physician/prescriptions#set_pharmacy'
  
#   post 'physician/prescriptions/add_patient' => 'physician/prescriptions#add_patient'
#   get 'physician/prescriptions/set_patient' => 'physician/prescriptions#set_patient'
# 
#   post 'physician/diagnostics/add_patient' => 'physician/diagnostics#add_patient'
#   get 'physician/diagnostics/set_patient' => 'physician/diagnostics#set_patient'
  
  post 'physician/patients/add_patient' => 'physician/patients#add_patient'
  get 'physician/patients/set_patient' => 'physician/patients#set_patient'
  
  post 'physician/patients/:id' => 'physician/patients#update'
  
  namespace :patient do
    get 'login' => 'auth/sessions#new', :as => :login
    post 'login' => 'auth/sessions#create', :as => :authenticate
    get 'logout' => 'auth/sessions#destroy', :as => :logout

    get 'password/reset' => 'auth/resets#new', :as => :new_password_reset
    post 'password/reset' => 'auth/resets#create', :as => :password_resets
    get 'password/reset/:token' => 'auth/resets#edit', :as => :edit_password_reset
    put 'password/reset' => 'auth/resets#update', :as => :password_reset
#     get 'prescription/authenticate' => 'prescriptions#authenticate', :as => :prescription_verify
#     post 'prescription/authenticate' => 'prescriptions#authenticate', :as => :prescription_authenticate
    
    scope :auth do
      resources :sessions, :controller => 'auth/sessions'
    end

    resources :prescriptions
    resources :diagnostics
    resources :dashboard do
      collection do
        patch :update_info
        patch :changed_password
        get :profile
        get :change_password
        get :permissions
        post :update_permission
        get :patient_history
        get 'prescription_details/:id', action: 'prescription_details'
      end
    end
    root to: 'dashboard#index'
  end
  
  namespace :admin do
    get 'login' => 'auth/sessions#new', :as => :login
    post 'login' => 'auth/sessions#create', :as => :authenticate
    get 'logout' => 'auth/sessions#destroy', :as => :logout
    
    get 'password/reset' => 'auth/password/resets#new', :as => :new_password_reset
    post 'password/reset' => 'auth/password/resets#create', :as => :password_resets
    get 'password/reset/:token' => 'auth/password/resets#edit', :as => :edit_password_reset
    put 'password/reset' => 'auth/password/resets#update', :as => :password_reset
    
    resources :physicians
    resources :pharmacists
    resources :pharmacies
    resources :laboratories
    resources :patients
    resources :technicians
    resources :drugs
    resources :admins
    resources :plans
    resources :tests
    resources :test_profiles
    resources :subscriptions
    
    scope :auth do
      resources :sessions, :controller => 'auth/sessions'
      resources :password_resets, :controller => 'auth/password/resets'
      
      scope :password do
        resources :resets
      end
    end
    
    root to: 'dashboard#index'
  end
  
  namespace :physician do
    get 'profile' => 'profile#edit', :as => :profile_edit
    post 'profile' => 'profile#update', :as => :profile_update
    
    get 'activate/:activation_code' => 'auth/activations#create', :as => :activation
    get '(:physician_id)/activation/resend' => 'auth/activations#new', :as => :new_activation
    post ':physician_id/activation/resend' => 'auth/activations#resend', :as => :resend_activation
    
    get 'password/reset' => 'auth/password/resets#new', :as => :new_password_reset
    post 'password/reset' => 'auth/password/resets#create', :as => :password_resets
    get 'password/reset/:token' => 'auth/password/resets#edit', :as => :edit_password_reset
    put 'password/reset' => 'auth/password/resets#update', :as => :password_reset
    
    get 'signup/check-email' => 'auth/signups#check_email'
    
    get 'login' => 'auth/sessions#new', :as => :login
    post 'login' => 'auth/sessions#create', :as => :authenticate
    get 'logout' => 'auth/sessions#destroy', :as => :logout
    get 'signup' => 'auth/signups#new', :as => :signup
    post 'signup' => 'auth/signups#create', :as => :register

    resources :patients do
      patch 'create_note'
      resources :prescriptions do
        patch 'set_prescript_note'
      end
      resources :diagnostics
      resources :test_results
    end
    
    resources :cards do
      post 'default'
    end
    resources :payments
    resources :messages
    resources :prescriptions
    resources :diagnostics
    
#     scope :auth do
#       resources :sessions, :controller => 'auth/sessions'
#       resources :registrations, :controller => 'auth/signups'
#       resources :password_resets, :controller => 'auth/password/resets'
#       
#       scope :password do
#         resources :resets
#       end
#     end
    
    resources :subscriptions
    resources :test_results, :path => 'test-results' do
      member do
        get 'archive'
        get 'review'
      end
    end
    
    root to: redirect('physician/patients/new')
  end
  
  namespace :pharmacist do
    get 'profile' => 'profile#edit', :as => :profile_edit
    post 'profile' => 'profile#update', :as => :profile_update
    
    get 'activate/:activation_code' => 'auth/activations#create', :as => :activation
    get '(:pharmacist_id)/activation/resend' => 'auth/activations#new', :as => :new_activation
    post ':pharmacist_id/activation/resend' => 'auth/activations#resend', :as => :resend_activation
    
    get 'password/reset' => 'auth/password/resets#new', :as => :new_password_reset
    post 'password/reset' => 'auth/password/resets#create', :as => :password_resets
    get 'password/reset/:token' => 'auth/password/resets#edit', :as => :edit_password_reset
    put 'password/reset' => 'auth/password/resets#update', :as => :password_reset
    
    get 'signup/check-email' => 'auth/signups#check_email'
    
    get 'login' => 'auth/sessions#new', :as => :login
    post 'login' => 'auth/sessions#create', :as => :authenticate
    get 'logout' => 'auth/sessions#destroy', :as => :logout
    get 'signup' => 'auth/signups#new', :as => :signup
    post 'signup' => 'auth/signups#create', :as => :register

    resources :physicians
    
    post 'prescriptions/:prescription_id/transfer' => 'prescriptions#transfer', :as => :create_prescription_transfer
    post 'prescriptions/import' => 'prescriptions#import', :as => :prescription_import
    
    get 'prescriptions/archived' => 'prescriptions#archived', :as => :archived_prescriptions
    get 'prescriptions/partials' => 'prescriptions#partials', :as => :partial_prescriptions
    
    resources :prescriptions do
      get 'ask_question' => 'prescriptions#ask_question', :as => :ask_question
      get 'transfer' => 'prescriptions#transfer', :as => :transfer
      
      get 'messages' => 'prescriptions#messages', :as => :new_message
      post 'messages' => 'prescriptions#messages', :as => :send_message
      
      post 'processing' => 'prescriptions#processing', :as => :processing
      patch 'ready' => 'prescriptions#ready', :as => :ready
      patch 'delivered' => 'prescriptions#delivered', :as => :delivered
    end
    
    resources :messages
    
#     scope :auth do
#       get 'registrations/check-email' => 'auth/signups#check_email'
#       
#       resources :sessions, :controller => 'auth/sessions'
#       resources :registrations, :controller => 'auth/signups'
#       resources :password_resets, :controller => 'auth/password/resets'
#       
#       scope :password do
#         resources :resets
#       end
#     end
    
    resources :subscriptions
    resources :pharmacies
    resources :pharmacists
    
    root to: 'prescriptions#index'
  end
  
  namespace :pharmacy do
    get 'profile' => 'profile#edit', :as => :profile_edit
    post 'profile' => 'profile#update', :as => :profile_update
    
    get 'activate/:activation_code' => 'auth/activations#create', :as => :activation
    get '(:pharmacy_id)/activation/resend' => 'auth/activations#new', :as => :new_activation
    post ':pharmacy_id/activation/resend' => 'auth/activations#resend', :as => :resend_activation
    
    get 'signup/check-email' => 'auth/signups#check_email'
    
    get 'login' => 'auth/sessions#new', :as => :login
    post 'login' => 'auth/sessions#create', :as => :authenticate
    get 'logout' => 'auth/sessions#destroy', :as => :logout
    get 'signup' => 'auth/signups#new', :as => :signup
    post 'signup' => 'auth/signups#create', :as => :register

    get 'password/reset' => 'auth/password/resets#new', :as => :new_password_reset
    post 'password/reset' => 'auth/password/resets#create', :as => :password_resets
    get 'password/reset/:token' => 'auth/password/resets#edit', :as => :edit_password_reset
    put 'password/reset' => 'auth/password/resets#update', :as => :password_reset
    
    post 'prescriptions/:prescription_id/transfer' => 'prescriptions#transfer', :as => :create_prescription_transfer
    post 'prescriptions/import' => 'prescriptions#import', :as => :prescription_import
    
    get 'prescriptions/archived' => 'prescriptions#archived', :as => :archived_prescriptions
    get 'prescriptions/partials' => 'prescriptions#partials', :as => :partial_prescriptions
    
    resources :prescriptions do
      get 'ask_question' => 'prescriptions#ask_question', :as => :ask_question
      get 'transfer' => 'prescriptions#transfer', :as => :transfer
      
      get 'messages' => 'prescriptions#messages', :as => :new_message
      post 'messages' => 'prescriptions#messages', :as => :send_message
      
      post 'processing' => 'prescriptions#processing', :as => :processing
      post 'ready' => 'prescriptions#ready', :as => :ready
      post 'delivered' => 'prescriptions#delivered', :as => :delivered
    end
    
    resources :cards do
      post 'default'
    end
    resources :payments
    resources :messages
    
#     scope :auth do
#       get 'registrations/check-email' => 'auth/signups#check_email'
# 
#       resources :sessions, :controller => 'auth/sessions'
#       resources :registrations, :controller => 'auth/signups'
#       resources :password_resets, :controller => 'auth/password/resets'
#       
#       scope :password do
#         resources :resets
#       end
#     end
    
    resources :subscriptions
    resources :pharmacists
    resources :disbursements
    
    root to: 'pharmacists#index'
  end
  
  namespace :test_center, path: 'test-center' do
    get 'profile' => 'profile#edit', :as => :profile_edit
    post 'profile' => 'profile#update', :as => :profile_update
    
    get 'activate/:activation_code' => 'auth/activations#create', :as => :activation
    get '(:test_center_id)/activation/resend' => 'auth/activations#new', :as => :new_activation
    post ':test_center_id/activation/resend' => 'auth/activations#resend', :as => :resend_activation
    
    get 'signup/check-email' => 'auth/signups#check_email'
    
    get 'login' => 'auth/sessions#new', :as => :login
    post 'login' => 'auth/sessions#create', :as => :authenticate
    get 'logout' => 'auth/sessions#destroy', :as => :logout
    get 'signup' => 'auth/signups#new', :as => :signup
    post 'signup' => 'auth/signups#create', :as => :register

    get 'password/reset' => 'auth/password/resets#new', :as => :new_password_reset
    post 'password/reset' => 'auth/password/resets#create', :as => :password_resets
    get 'password/reset/:token' => 'auth/password/resets#edit', :as => :edit_password_reset
    put 'password/reset' => 'auth/password/resets#update', :as => :password_reset
    
    post 'diagnostics/:diagnostic_id/transfer' => 'diagnostics#transfer', :as => :create_diagnostic_transfer
    post 'diagnostics/import' => 'diagnostics#import', :as => :diagnostic_import
    
    get 'diagnostics/archived' => 'diagnostics#archived', :as => :archived_diagnostics
    get 'diagnostics/partials' => 'diagnostics#partials', :as => :partial_diagnostics
    
    resources :diagnostics do
      get 'ask_question' => 'diagnostics#ask_question', :as => :ask_question
      get 'transfer' => 'diagnostics#transfer', :as => :transfer
      
      get 'messages' => 'diagnostics#messages', :as => :new_message
      post 'messages' => 'diagnostics#messages', :as => :send_message
      
      post 'processing' => 'diagnostics#processing', :as => :processing
      post 'ready' => 'diagnostics#ready', :as => :ready
      post 'delivered' => 'diagnostics#delivered', :as => :delivered
      
      member do
        patch 'upload' => 'diagnostics#upload'
      end
    end
    
    resources :cards do
      post 'default'
    end
    resources :payments
    resources :technicians
    resources :messages
    
#     scope :auth do
#       get 'registrations/check-email' => 'auth/signups#check_email'
# 
#       resources :sessions, :controller => 'auth/sessions'
#       resources :registrations, :controller => 'auth/signups'
#       resources :password_resets, :controller => 'auth/password/resets'
#       
#       scope :password do
#         resources :resets
#       end
#     end
    
    resources :subscriptions
    
    root to: 'technicians#index'
  end
  
  namespace :technician do
    get 'profile' => 'profile#edit', :as => :profile_edit
    post 'profile' => 'profile#update', :as => :profile_update
    
    get 'activate/:activation_code' => 'auth/activations#create', :as => :activation
    get '(:technician_id)/activation/resend' => 'auth/activations#new', :as => :new_activation
    post ':technician_id/activation/resend' => 'auth/activations#resend', :as => :resend_activation
    
    get 'signup/check-email' => 'auth/signups#check_email'
    
    get 'login' => 'auth/sessions#new', :as => :login
    post 'login' => 'auth/sessions#create', :as => :authenticate
    get 'logout' => 'auth/sessions#destroy', :as => :logout
    get 'signup' => 'auth/signups#new', :as => :signup
    post 'signup' => 'auth/signups#create', :as => :register

    get 'password/reset' => 'auth/password/resets#new', :as => :new_password_reset
    post 'password/reset' => 'auth/password/resets#create', :as => :password_resets
    get 'password/reset/:token' => 'auth/password/resets#edit', :as => :edit_password_reset
    put 'password/reset' => 'auth/password/resets#update', :as => :password_reset
    
    post 'diagnostics/:diagnostic_id/transfer' => 'diagnostics#transfer', :as => :create_diagnostic_transfer
    post 'diagnostics/import' => 'diagnostics#import', :as => :diagnostic_import
    
    get 'diagnostics/closed' => 'diagnostics#index_closed', :as => :closed_diagnostics
    get 'diagnostics/partials' => 'diagnostics#partials', :as => :partial_diagnostics
    
    resources :diagnostics do
      get 'ask_question' => 'diagnostics#ask_question', :as => :ask_question
      get 'transfer' => 'diagnostics#transfer', :as => :transfer
      
      get 'messages' => 'diagnostics#messages', :as => :new_message
      post 'messages' => 'diagnostics#messages', :as => :send_message
      
      post 'processing' => 'diagnostics#processing', :as => :processing
      post 'ready' => 'diagnostics#ready', :as => :ready
      post 'delivered' => 'diagnostics#delivered', :as => :delivered
      
      member do
        patch 'upload' => 'diagnostics#upload'
      end
    end
    
    resources :messages
    
#     scope :auth do
#       get 'registrations/check-email' => 'auth/signups#check_email'
# 
#       resources :sessions, :controller => 'auth/sessions'
#       resources :registrations, :controller => 'auth/signups'
#       resources :password_resets, :controller => 'auth/password/resets'
#       
#       scope :password do
#         resources :resets
#       end
#     end
    
    root to: 'diagnostics#index'
  end
  
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      
      get 'allergies' => 'allergies#search', :as => :search_allergies
      get 'illnesses' => 'illnesses#search', :as => :search_illnesses
      get 'drugs' => 'drugs#search', :as => :search_drugs
      get 'pharmacies' => 'pharmacies#search', :as => :search_pharmacies
      get 'laboratories' => 'laboratories#search', :as => :search_laboratories
      get 'patients' => 'patients#search', :as => :search_patients
      get 'dosage_duration_units' => 'dosage_duration_units#search', :as => :search_dosage_duration_units
      
      post 'patient/verify/send_code' => 'patients#send_verification_code', :as => :patient_send_code
      post 'patient/verify' => 'patients#verify', :as => :patient_verify

      resources :patients do
      end
      
    end
  end
  
  root to: 'home#index'
end
