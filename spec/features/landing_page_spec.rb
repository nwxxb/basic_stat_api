# frozen_string_literal: true

RSpec.describe 'landing page', type: :feature do
  def app
    Rack::Builder.new do
      map('/api') { run BasicStatApi::Calculations }
      map('/') { run BasicStatApi::Pages }
    end
  end

  before do
    Capybara.app = app
  end

  it 'has title' do
    visit('/')
    expect(page).to have_content(/Basic.+Stat.+Api/)
  end

  it 'provide functional demo', js: true do
    visit('/')
    fill_in 'Data Payload', with: '60, 70, 100, 80, 50, 50, 75'
    click_button 'Submit'
    expect(page).to have_content(/mean.+:.+69\.285/)
    expect(page).to have_content(/median.+:.+70/)
    expect(page).to have_content(/mode.+:.+50/)
    expect(page).to have_content(/standard_deviation.+:.+16.5677/)
  end
end
