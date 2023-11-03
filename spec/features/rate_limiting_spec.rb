# frozen_string_literal: true

FIXED_LIMIT = 10
FIXED_DURATION = 10

RSpec.describe 'Apply Rate limiting', type: :feature do
  def app
    Rack::Builder.new do
      use(
        BasicStatApi::CustomRateLimiter, 
        limit: FIXED_LIMIT, 
        duration: FIXED_DURATION,
        exceptions: ->(env) { /bypass/.match? env['PATH_INFO'] }
      )
      map('/api') { run BasicStatApi::Calculations }
      map('/') { run Sinatra.new { get('/bypass') { 'bypassed' } } }
    end
  end

  it "working fine if API call is not more than #{FIXED_LIMIT}" do
    get('/api/ping')
    get('/api/ping')

    expect(last_response.status).to eq(200)
  end

  it "working fine exception conditions is satisfied" do
    get('/bypass')
    (FIXED_LIMIT + 1).times do
      get('/bypass')
    end
    expect(last_response.status).to eq(200)
  end

  it "halt if API call is more than #{FIXED_LIMIT}" do
    (FIXED_LIMIT + 1).times do
      get('/api/ping')
    end
    expect(last_response.status).to eq(429)
    expect(JSON.parse(last_response.body)['error']).to eq('limit exceeded')
  end

  it 'open again if duration ended' do
    FIXED_LIMIT.times do
      get('/api/ping')
    end
    sleep(FIXED_DURATION + 1)
    get('/api/ping')

    expect(last_response.status).to eq(200)
  end
end
