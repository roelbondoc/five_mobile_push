require 'faraday'

module Faraday
  class Response::Errors < Response::Middleware

    begin
      def self.register_on_complete(env)
        env[:response].on_complete do |finished_env|
          case finished_env[:status]
          when 400
            raise FiveMobilePush::GeneralError, finished_env[:body]
          when 401
            raise FiveMobilePush::UnauthorizedError, finished_env[:body]
          when 500
            raise FiveMobilePush::ServerError, 'push.fivemobile.com is currently down'
          end
        end
      end
    rescue LoadError, NameError => e
      self.load_error = e
    end

    def initialize(app)
      super
      @parser = nil
    end

  end
end
