# frozen_string_literal: true

module BasicStatApi
  # Routes: contains all required endpoints
  class Routes < Sinatra::Base
    get '/ping' do
      content_type 'text/plain'

      'pong'
    end

    helpers do
      def mean(data)
        data.sum(0.0) / data.length
      end

      def median(data)
        sorted_values = data.sort
        if sorted_values.length.odd?
          sorted_values[((sorted_values.length + 1) / 2) - 1]
        else
          [
            sorted_values[((sorted_values.length + 1) / 2.0).ceil - 1],
            sorted_values[(sorted_values.length / 2) - 1]
          ].sum(0.0) / 2
        end
      end

      def mode(data)
        value_count = data.map.each_with_object({}) do |val, counter|
          counter[val] = if counter[val].nil?
                           1
                         else
                           counter[val] + 1
                         end
        end

        value_count.select do |_, value|
          value == value_count.values.max
        end.keys
      end

      def standard_deviation(data, is_sample)
        mean = mean(data)
        length = is_sample ? data.length - 1 : data.length
        Math.sqrt(
          data.map do |val|
            ((val.to_f - mean)**2)
          end.sum / length
        )
      end
    end

    post '/mean' do
      content_type 'application/json'

      begin
        data = JSON.parse(request.body.read)['data']
        mean = mean(data)
        return { mean: }.to_json
      rescue JSON::GeneratorError, NoMethodError
        error 400, { error: 'invalid input' }.to_json
      end
    end

    post '/median' do
      content_type 'application/json'

      begin
        data = JSON.parse(request.body.read)['data']
        median = median(data)

        return { median: }.to_json
      rescue JSON::GeneratorError, NoMethodError
        error 400, { error: 'invalid input' }.to_json
      end
    end

    post '/mode' do
      content_type 'application/json'

      begin
        data = JSON.parse(request.body.read)['data']
        mode = mode(data)

        return { mode: }.to_json
      rescue JSON::GeneratorError, NoMethodError
        error 400, { error: 'invalid input' }.to_json
      end
    end

    post '/standard_deviation' do
      content_type 'application/json'

      begin
        data, sample_flag = JSON.parse(request.body.read).values
        standard_deviation = standard_deviation(data, sample_flag)

        return { standard_deviation: }.to_json
      rescue JSON::GeneratorError, NoMethodError
        error 400, { error: 'invalid input' }.to_json
      end
    end

    get '/' do
      # please list all available endpoints here
      content_type 'application/json'
      url_info = {}
      self.class.routes.each_pair do |method, list|
        next unless method != 'HEAD'

        url_info[method] = list.map do |route|
          request.url + route.first.to_s[1..]
        end
      end

      return url_info.to_json
    end
  end
end
