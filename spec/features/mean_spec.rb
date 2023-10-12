# frozen_string_literal: true

RSpec.describe '/mean endpoint', type: :feature do
  def app
    Rack::Builder.new do
      use(BasicStatApi::CustomRateLimiter, limit: 10, duration: 3600)
      run Rack::URLMap.new('/' => BasicStatApi::Routes)
    end
  end

  it 'return correct average score' do
    setup_header(content_type: 'application/json', accept: 'application/json')

    post('/mean', { data: [60, 70, 100, 80, 50, 50, 75] }.to_json)
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)['mean']).to be_within(0.01).of(69.285)
  end

  it 'return correct mean score (2)' do
    setup_header(content_type: 'application/json', accept: 'application/json')

    post('/mean', { data: [10, 10, 10, 10] }.to_json)
    expect(last_response.status).to eq(200)
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)['mean']).to be_within(0.01).of(10)
  end
end
