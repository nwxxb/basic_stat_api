# frozen_string_literal: true

# Class that contains all required endpoints
class StatApi < Sinatra::Base
  use CustomRateLimiter, limit: 100, duration: 86_400
  use Rack::JSONBodyParser

  get '/ping' do
    content_type 'text/plain'

    'pong'
  end

  post '/mean' do
    content_type 'application/json'

    data = JSON.parse(request.body.read)['data']
    mean = data.sum(0.0) / data.length

    return { mean: }.to_json
  end

  post '/median' do
    content_type 'application/json'

    data = JSON.parse(request.body.read)['data']
    sorted_values = data.sort
    median = if sorted_values.length.odd?
               sorted_values[((sorted_values.length + 1) / 2) - 1]
             else
               [
                 sorted_values[((sorted_values.length + 1) / 2.0).ceil - 1],
                 sorted_values[(sorted_values.length / 2) - 1]
               ].sum(0.0) / 2
             end

    return { median: }.to_json
  end

  post '/mode' do
    content_type 'application/json'

    data = JSON.parse(request.body.read)['data']
    value_count = data.map
                      .each_with_object({}) do |val, counter|
      counter[val] = if counter[val].nil?
                       1
                     else
                       counter[val] + 1
                     end
    end

    mode = value_count.select do |_, value|
      value == value_count.values.max
    end.keys

    return { mode: }.to_json
  end

  post '/standard_deviation' do
    content_type 'application/json'

    data, sample_flag = JSON.parse(request.body.read).values
    mean = data.sum(0.0) / data.length
    length = sample_flag ? data.length - 1 : data.length
    standard_deviation = Math.sqrt(
      data.map do |val|
        ((val.to_f - mean)**2)
      end.sum / length
    )

    return { standard_deviation: }.to_json
  end
end
