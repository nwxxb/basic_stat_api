# frozen_string_literal: true

require 'dotenv'
Dotenv.load(".env.#{ENV['RACK_ENV']}")
require 'bundler/setup'
Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

# top level module / namespace
module BasicStatApi
end

require './app/custom_rate_limiter'
require './app/calculations'
require './app/main_app'
