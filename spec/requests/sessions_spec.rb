require 'rails_helper'

describe 'Sessions', type: :request do
  let(:email) { 'email@email.com' }
  let(:password) { 'password' }
  let(:invalid_password) { 'invalid' }
  let!(:existing_user) { FactoryBot.create(:user, email:, password:) }
  let(:login_url) { '/api/v1/sign_in' }
  let(:logout_url) { '/api/v1/sign_out' }

  context 'when signing in' do
    before do
      post login_url, params: {
        user: { email:, password: }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns a token' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns the user email' do
      expect(json_body['user']).to include('email' => email)
    end
  end

  context 'when an invalid password is passed' do
    before do
      post login_url, params: {
        user: { email:, password: invalid_password }
      }
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end

    it 'does not return a token' do
      expect(response.headers['Authorization']).not_to be_present
    end
  end
end
