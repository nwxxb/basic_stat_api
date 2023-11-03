# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)
Dotenv.load(".env.#{ENV['RACK_ENV']}")

# top level module / namespace
module BasicStatApi
end

require './app/custom_rate_limiter'
require './app/calculations'
require './app/main_app'
