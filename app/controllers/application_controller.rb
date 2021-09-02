class ApplicationController < ActionController::Base
  before_action :set_breadcrumbs
  protect_from_forgery with: :null_session
  add_flash_types :info

     before_action :configure_permitted_parameters, if: :devise_controller?

     protected

          def configure_permitted_parameters
               devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:clothing_preference, :email, :password)}

               devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:clothing_preference, :email, :password, :current_password)}
          end
    private
    def set_breadcrumbs

      if session[:breadcrumbs]
        @breadcrumbs = session[:breadcrumbs]
      else
        @breadcrumbs = Array.new
      end

      @breadcrumbs.push(request.url)

      if @breadcrumbs.count > 4
        @breadcrumbs.shift
      end

      session[:breadcrumbs] = @breadcrumbs
    end
end
