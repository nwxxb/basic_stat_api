class StatApi < Sinatra::Base
  get "/ping" do
    'pong'
  end

  post "/mean" do
    content_type 'application/json'

    mean = params['data'].map(&:to_i).sum(0.0) / params['data'].length

    return { mean: mean }.to_json
  end

  post "/median" do
    content_type 'application/json'

    sorted_values = params['data'].map(&:to_i).sort
    if sorted_values.length.odd?
      median = sorted_values[((sorted_values.length + 1) / 2) - 1]
    else
      median = [
        sorted_values[((sorted_values.length + 1) / 2.0).ceil - 1], 
        sorted_values[((sorted_values.length) / 2) - 1]
      ].sum(0.0) / 2
    end

    return { median: median }.to_json
  end

  post "/mode" do
    content_type 'application/json'

    value_count = params['data'].map(&:to_i)
      .inject({}) do |counter, val|
        if counter[val].nil?
          counter[val] = 1
        else
          counter[val] = counter[val] + 1
        end

        counter
      end

    mode = value_count.select do |key, value|
      value == value_count.values.max
    end.keys

    return { mode: mode }.to_json
  end
end
