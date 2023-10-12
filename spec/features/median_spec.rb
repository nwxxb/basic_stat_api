# frozen_string_literal: true

RSpec.describe '/median endpoint', type: :feature do
  def app
    Rack::Builder.new do
      use(BasicStatApi::CustomRateLimiter, limit: 10, duration: 3600)
      run Rack::URLMap.new('/' => BasicStatApi::Routes)
    end
  end

  it 'return correct middle value' do
    setup_header(content_type: 'application/json', accept: 'application/json')

    post '/median', { data: [3, 1, 3, 7, 6, 9, 8] }.to_json
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)['median']).to be_within(0.01).of(6)
  end

  it 'return correct median' do
    setup_header(content_type: 'application/json', accept: 'application/json')

    post '/median', { data: [3, 5, 2, 2, 8, 6, 8, 9] }.to_json
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)['median']).to be_within(0.01).of(5.5)
  end
end
