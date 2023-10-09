# frozen_string_literal: true

module BasicStatApi
  # Main App, compile all needed components like middleware and route
  class MainApp < Sinatra::Base
    use BasicStatApi::CustomRateLimiter, limit: 100, duration: 86_400
    use Rack::JSONBodyParser

    use BasicStatApi::Routes
  end
end
