# frozen_string_literal: true

FIXED_LIMIT = 10
FIXED_DURATION = 10

RSpec.describe 'Apply Rate limiting', type: :feature do
  def app
    Rack::Builder.new do
      use(CustomRateLimiter, limit: FIXED_LIMIT, duration: FIXED_DURATION)

      run Rack::URLMap.new('/' => StatApi)
    end
  end

  it "working fine if API call is not more than #{FIXED_LIMIT}" do
    get('/ping')
    get('/ping')

    expect(last_response.status).to eq(200)
  end

  it "halt if API call is more than #{FIXED_LIMIT}" do
    (FIXED_LIMIT + 1).times do
      get('/ping')
    end
    expect(last_response.status).to eq(429)
    expect(JSON.parse(last_response.body)['error']).to eq('limit exceeded')
  end

  it 'open again if duration ended' do
    FIXED_LIMIT.times do
      get('/ping')
    end
    sleep(FIXED_DURATION + 1)
    get('/ping')

    expect(last_response.status).to eq(200)
  end
end
