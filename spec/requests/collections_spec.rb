require 'rails_helper'

RSpec.describe "Collections", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe "GET /index" do
    let(:collections_size) { 5 }
    let!(:collections) { FactoryBot.create_list(:collection, collections_size, user:) }

    let(:index_url) { '/api/v1/collections' }

    context 'when logged in' do
      before do
        login_with_api(user)

        get index_url, headers: {
          'Authorization': response.headers['Authorization']
        }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns user collections' do
        expect(json_body['collections'].size).to eq(collections_size)
      end
    end

    context 'When Authorization header is not passed' do
      it 'returns 401' do
        get index_url

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /collections/:id" do
    let(:name) { 'Collection name' }
    let!(:collection) { FactoryBot.create(:collection, name:, user:) }
    let!(:other_user) { FactoryBot.create(:user) }

    let(:url) { "/api/v1/collections/#{collection.id}" }

    context 'when logged in' do
      before do
        login_with_api(user)

        get url, headers: {
          'Authorization': response.headers['Authorization']
        }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct collection' do
        expect(json_body['collection']['name']).to eq(name)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        get url

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when collection does no belong to user' do
      before do
        login_with_api(other_user)

        get url, headers: {
          'Authorization': response.headers['Authorization']
        }
      end

      it 'returns 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/collections' do
    let(:url) { '/api/v1/collections' }

    context 'when logged in' do
      before do
        login_with_api(user)

        post(
          url,
          headers: { 'Authorization': response.headers['Authorization'] },
          params: {
            collection: {
              name: 'name',
            }
          }
        )
      end

      it 'returns 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        post url, params: {
          collection: {
            name: 'name',
          }
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when name is missing' do
      before do
        login_with_api(user)

        post(
          url,
          headers: { 'Authorization': response.headers['Authorization'] },
          params: {
            collection: {
              name: '',
            }
          }
        )
      end

      it 'returns 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/collections/:id" do
    let!(:other_user) { FactoryBot.create(:user) }
    let!(:collection) { FactoryBot.create(:collection, user:) }
    let(:url) { "/api/v1/collections/#{collection.id}" }
    let(:wrong_url) { '/api/v1/collections/456' }

    context 'when logged in' do
      before do
        login_with_api(user)

        delete url, headers: {
          'Authorization':  response.headers['Authorization']
        }
      end

      it 'returns 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        delete url

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when collection does not exist' do
      before do
        login_with_api(user)

        delete wrong_url, headers: {
          'Authorization':  response.headers['Authorization']
        }
      end

      it 'returns 404' do
        expect(response).to have_http_status(:not_found)
      end
    end


    context 'when user does not own collection' do
      before do
        login_with_api(other_user)

        delete url, headers: {
          'Authorization':  response.headers['Authorization']
        }
      end

      it 'returns 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /api/v1/collections/:id" do
    let!(:other_user) { FactoryBot.create(:user) }
    let!(:collection) { FactoryBot.create(:collection, user:) }

    let(:new_name) { 'New name' }

    let(:url) { "/api/v1/collections/#{collection.id}" }
    let(:wrong_url) { '/api/v1/collections/456' }

    context 'when logged in' do
      before do
        login_with_api(user)

        patch(
          url,
          headers: {
            'Authorization':  response.headers['Authorization']
          },
          params: {
            collection: {
              name: new_name
            }
          }
        )
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the collection' do
        expect(json_body['collection']['name']).to eq(new_name)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        patch url, params: {
          collection: {
            name: new_name
          }
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when collection does not exist' do
      before do
        login_with_api(user)

        patch(
          wrong_url,
          headers: {
            'Authorization':  response.headers['Authorization']
          },
          params: {
            collection: {
              name: new_name
            }
          }
        )
      end

      it 'returns 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user does not own collection' do
      before do
        login_with_api(other_user)

        patch(
          url,
          headers: {
            'Authorization':  response.headers['Authorization']
          },
          params: {
            collection: {
              name: new_name
            }
          }
        )
      end

      it 'returns 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
