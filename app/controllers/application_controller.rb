class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    case resource.role
    when "admin"
      admin_dashboard_path
    when "doctor"
      doctors_path
    when "patient"
      new_patient_path
    else
      root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :role ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :role ])
  end
end
