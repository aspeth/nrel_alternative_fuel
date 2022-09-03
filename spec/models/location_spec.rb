require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "relationships" do
    it { should have_many(:stations) }
  end
end
