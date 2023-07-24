RSpec.describe 'calculate mode' do
  def app
    StatApi
  end

  describe "mode" do
    it "return the most frequent values" do
      header 'CONTENT_TYPE', 'application/json'
      header 'ACCEPT', 'application/xml'

      post '/mode', {data: [3, 1, 3, 7, 6, 9, 8]}.to_json
      expect(last_response.ok?).to be_truthy
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['mode']).to eq([3])
    end

    it "return the most frequent values" do
      header 'CONTENT_TYPE', 'application/json'
      header 'ACCEPT', 'application/xml'

      post '/mode', {data: [3, 5, 2, 2, 8, 6, 8, 9]}.to_json
      expect(last_response.ok?).to be_truthy
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['mode']).to eq([2, 8])
    end
  end
end
