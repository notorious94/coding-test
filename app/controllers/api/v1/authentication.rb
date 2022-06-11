module API
  module V1
    module Authentication
      extend ActiveSupport::Concern

      included do
        before do
          authenticate_api_access_token
          check_authentication
        end

        helpers do
          def authenticate_api_access_token
            has_valid_access_token = AuthenticateAccessToken.new(request.headers).call
            return true if has_valid_access_token

            e = APIError::ApiAccessTokenError.new
            error!({ error: e.message, error_code: e.error_code }, 401)
          end

          def current_user
            @current_user = AuthorizeJwtToken.new(request.headers).call
          rescue StandardError => e
            Rails.logger.error "Error occurred at the time of authenticating the API. #{e.message}"
            error!({ error: e.message, error_code: e.try(:error_code) }, 401)
          rescue StandardError => e
            Rails.logger.error "Error occurred at the time of authenticating the API. #{e.message}"
            Rails.logger.error e.backtrace.join("\n")
            e = APIError::InternalServerError.new
            error!({ error: e.message, error_code: e.error_code }, 500)
          end

          def check_authentication
            unless current_user.present?
              e = APIError::NotAuthorize.new
              error!({ error: e.message, error_code: e.error_code }, 401)
            end
          end

        end
      end
    end
  end
end
