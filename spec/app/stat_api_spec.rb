RSpec.describe StatApi do
  def app
    StatApi
  end

  describe "basic" do
    it "return hello world on main route" do
      get '/'
      expect(last_response.body).to eq('hello world')
    end
  end
end
