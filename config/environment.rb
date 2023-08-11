# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)
Dotenv.load(".env.#{ENV['RACK_ENV']}")
Dir['./app/*.rb'].sort.each do |file|
  require file
end
