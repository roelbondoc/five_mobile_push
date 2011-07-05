require 'faraday'

# Provides us protection against the FiveMobilePush API's error handling which
# is currently incomplete.
module Faraday
  class Response::Errors < Response::Middleware
    def call(env)
      @app.call(env).on_complete do
        case env[:status]
          when 400
            raise FiveMobilePush::GeneralError, response_values(env)
          when 401
            raise FiveMobilePush::UnauthorizedError, response_values(env)
          when 500
            env[:body] = 'push.fivemobile.com is currently down'
            raise FiveMobilePush::ServerError, response_values(env)
        end
      end
    end

    # Copied from Faraday
    def response_values(env)
      { :status => env[:status], :headers => env[:response_headers], :body => env[:body] }
    end
  end
end
