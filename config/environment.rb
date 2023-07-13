require 'bundler/setup'
Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)
Dir['./app/*.rb'].each do |file|
  require file
end
