require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:notes).dependent(:destroy) }
    it { should have_many(:tags).dependent(:destroy) }
    it { should have_many(:collections).dependent(:destroy) }
  end
end
