require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:collection).optional }
    it { should have_and_belong_to_many(:tags) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end
end
