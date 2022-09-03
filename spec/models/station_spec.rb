require 'rails_helper'

RSpec.describe Station, type: :model do
  describe "relationships" do
    it { should belong_to(:location) }
  end
end
