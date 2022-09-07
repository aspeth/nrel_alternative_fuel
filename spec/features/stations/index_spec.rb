require 'rails_helper'

RSpec.describe 'stations index page' do
  it 'has a list of nearby stations' do
    visit '/stations?zipcode=80207'

    within "#stations" do
      expect(page).to have_content("Denver Museum of Nature & Science")
      expect(page).to have_content("2001 Colorado Blvd Denver, CO 80205")
      expect(page).to have_content("Public")
      
      expect(page).to_not have_content("Los Angeles County - Registrar-Recorder - County Clerk")
      expect(page).to_not have_content("12400 E Imperial Hwy Norwalk, CA 90650")
    end
  end
end