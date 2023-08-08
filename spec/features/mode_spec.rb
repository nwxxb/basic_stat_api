# frozen_string_literal: true

RSpec.describe 'calculate mode', type: :feature do
  def app
    StatApi
  end

  describe 'mode' do
    it 'return the most frequent values' do
      setup_header(content_type: 'application/json', accept: 'application/json')

      post '/mode', { data: [3, 1, 3, 7, 6, 9, 8] }.to_json
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['mode']).to eq([3])
    end

    it 'return the most frequent values (2)' do
      setup_header(content_type: 'application/json', accept: 'application/json')

      post '/mode', { data: [3, 5, 2, 2, 8, 6, 8, 9] }.to_json
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['mode']).to eq([2, 8])
    end
  end
end
