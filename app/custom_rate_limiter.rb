# frozen_string_literal: true

# Rack middleware to limit API call
class CustomRateLimiter
  def initialize(app, limit:, duration:)
    @app = app
    @limit = limit
    @duration = duration
    @redis = Redis.new
  end

  def call(env)
    key =  "#{ENV['RACK_ENV']}:limit:#{env['REMOTE_ADDR']}"
    count = @redis.incr(key)
    @redis.expire(key, @duration) if count == 1

    if count > @limit
      [429, { 'Content-Type' => 'application/json' }, { error: 'limit exceeded' }.to_json]
    else
      @app.call(env)
    end
  end
end
