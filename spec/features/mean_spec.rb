# frozen_string_literal: true

RSpec.describe 'Calculate Mean/Average' do
  def app
    StatApi
  end

  describe 'mean' do
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
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['mean']).to be_within(0.01).of(10)
    end
  end
end
