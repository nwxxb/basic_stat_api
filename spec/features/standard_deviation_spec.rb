# frozen_string_literal: true

RSpec.describe 'Calculate Standard Deviation' do
  def app
    StatApi
  end

  describe 'standard deviation' do
    it 'return correct standard deviation (sample)' do
      setup_header(content_type: 'application/json', accept: 'application/json')

      post('/standard_deviation', { data: [60, 70, 100, 80, 50, 50, 75], is_sample: true }.to_json)
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['standard_deviation']).to be_within(0.01).of(17.895197)
    end

    it 'return correct standard deviation (population)' do
      setup_header(content_type: 'application/json', accept: 'application/json')

      post('/standard_deviation', { data: [60, 70, 100, 80, 50, 50, 75] }.to_json)
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['standard_deviation']).to be_within(0.01).of(16.56773)
    end
  end
end
