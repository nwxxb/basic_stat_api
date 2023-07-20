RSpec.describe 'Calculate Mean/Average'  do
  def app
    StatApi
  end

  describe "mean" do
    it "return correct average score" do
      post '/mean', data: [60, 70, 100, 80, 50, 50, 75]
      expect(last_response.ok?).to be_truthy
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['mean']).to be_within(0.01).of(69.285)
    end

    it "return correct mean" do
      post '/mean', data: [10, 10, 10, 10]
      expect(last_response.ok?).to be_truthy
      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body)['mean']).to be_within(0.01).of(10)
    end
  end
end