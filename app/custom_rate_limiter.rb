# frozen_string_literal: true

module BasicStatApi
  # Rack middleware to limit API call
  class CustomRateLimiter
    def initialize(app, limit:, duration:, exceptions: nil)
      @app = app
      @limit = limit
      @duration = duration
      @redis = Redis.new(
        host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db: ENV['REDIS_DB']
      )
      @exceptions = exceptions
    end

    def call(env)
      if !@exceptions.nil? && @exceptions.call(env)
        @app.call(env)
      else
        key = "limit:#{env['REMOTE_ADDR']}"
        count = @redis.incr(key)
        @redis.expire(key, @duration) if count == 1

        if count > @limit
          [429, { 'Content-Type' => 'application/json' }, { error: 'limit exceeded' }.to_json]
        else
          @app.call(env)
        end
      end
    end
  end
end
