# frozen_string_literal: true

RSpec.describe '/summary endpoint', type: :feature do
  def app
    Rack::Builder.new do
      use(BasicStatApi::CustomRateLimiter, limit: 10, duration: 3600)
      run Rack::URLMap.new('/' => BasicStatApi::Routes)
    end
  end

  it 'return all value' do
    setup_header(content_type: 'application/json', accept: 'application/json')

    post '/summary', { data: [60, 70, 100, 80, 50, 50, 75], is_sample: true }.to_json
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)['mean']).to be_within(0.01).of(69.285)
    expect(JSON.parse(last_response.body)['median']).to be_within(0.01).of(70)
    expect(JSON.parse(last_response.body)['mode']).to eq([50])
    expect(JSON.parse(last_response.body)['standard_deviation']).to be_within(0.01).of(17.895197)
  end

  it 'get image if accept == image/*' do
    setup_header(content_type: 'application/json', accept: 'image/jpg')

    post '/summary', { data: [60, 70, 100, 80, 50, 50, 75], is_sample: true }.to_json
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('image/jpg')
  end

  it 'return 400 code for invalid input' do
    setup_header(content_type: 'application/json', accept: 'application/json')

    post('/summary', {}.to_json)
    expect(last_response.status).to eq(400)
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)['error']).to eq('invalid input')
  end
end
