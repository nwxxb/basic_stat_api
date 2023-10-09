# frozen_string_literal: true

require './config/environment'
# run Rack::URLMap.new('/' => StatApi)
run BasicStatApi::MainApp
