# frozen_string_literal: true

module BasicStatApi
  # Main App, compile all needed components like middleware and route
  class MainApp
    def initialize(rate_limit:, rate_duration:)
      @app = Rack::Builder.new do
        use(BasicStatApi::CustomRateLimiter, limit: rate_limit, duration: rate_duration)
        map('/api') { run BasicStatApi::Calculations }
        map('/') { run Sinatra.new { get('/') { erb :index } } }
      end
    end

    def call(env)
      @app.call(env)
    end
  end
end
