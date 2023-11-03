# frozen_string_literal: true

RSpec.describe '/mode endpoint', type: :feature do
  def app
    BasicStatApi::MainApp.new(rate_limit: 10, rate_duration: 3600)
  end

  it 'return the most frequent values' do
    setup_header(content_type: 'application/json', accept: 'application/json')

    post '/api/mode', { data: [3, 1, 3, 7, 6, 9, 8] }.to_json
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)['mode']).to eq([3])
  end

  it 'return the most frequent values (2)' do
    setup_header(content_type: 'application/json', accept: 'application/json')

    post '/api/mode', { data: [3, 5, 2, 2, 8, 6, 8, 9] }.to_json
    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)['mode']).to eq([2, 8])
  end

  it 'return 400 code for invalid input' do
    setup_header(content_type: 'application/json', accept: 'application/json')

    post('/api/mode', {}.to_json)
    expect(last_response.status).to eq(400)
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)['error']).to eq('invalid input')
  end
end
