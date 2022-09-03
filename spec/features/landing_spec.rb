require 'rails_helper'

RSpec.describe 'landing page' do
  it 'allows user to input zipcode to search for nearby stations' do
    visit '/'

    fill_in "Zip Code", with: "80207"
    click_button "Search"

    expect(current_path).to eq("/stations")
  end
end