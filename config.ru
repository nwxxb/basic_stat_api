# frozen_string_literal: true

require './config/environment'
run BasicStatApi::MainApp.new(
  rate_limit: 100, 
  rate_duration: 86_400,
  rate_exceptions_condition: ->(env) {!(/api/.match?(env['PATH_INFO']))}
)
