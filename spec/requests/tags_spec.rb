require 'rails_helper'

RSpec.describe "Tags", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe "GET /index" do
    let(:tags_size) { 5 }
    let!(:tags) { FactoryBot.create_list(:tag, tags_size, user:) }

    let(:index_url) { '/api/v1/tags' }

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

      it 'returns user tags' do
        expect(json_body['tags'].size).to eq(tags_size)
      end
    end

    context 'When Authorization header is not passed' do
      it 'returns 401' do
        get index_url

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /notes/:id/tags" do
    let(:tags_size) { 5 }
    let!(:note) { FactoryBot.create(:note, user:) }
    let!(:tags) { FactoryBot.create_list(:tag, tags_size, user:, notes: [note]) }
    let!(:other_user) { FactoryBot.create(:user) }

    let(:url) { "/api/v1/notes/#{note.id}/tags" }


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

      it 'returns note tags' do
        expect(json_body['tags'].size).to eq(tags_size)
      end
    end

    context "when user does not own tag" do
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

    context 'When Authorization header is not passed' do
      it 'returns 401' do
        get url

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /tags/:id" do
    let(:name) { 'Tag name' }
    let!(:tag) { FactoryBot.create(:tag, name:, user:) }
    let!(:other_user) { FactoryBot.create(:user) }

    let(:url) { "/api/v1/tags/#{tag.id}" }

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

      it 'returns the correct tag' do
        expect(json_body['tag']['name']).to eq(name)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        get url

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when tag does not belong to user' do
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

  describe 'POST /api/v1/tags' do
    let(:url) { '/api/v1/tags' }

    context 'when logged in' do
      before do
        login_with_api(user)

        post(
          url,
          headers: { 'Authorization': response.headers['Authorization'] },
          params: {
            tag: {
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
          tag: {
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
            tag: {
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

  describe "DELETE /api/v1/tags/:id" do
    let!(:other_user) { FactoryBot.create(:user) }
    let!(:tag) { FactoryBot.create(:tag, user:) }
    let(:url) { "/api/v1/tags/#{tag.id}" }
    let(:wrong_url) { '/api/v1/tags/456' }

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

    context 'when tag does not exist' do
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


    context 'when user does not own tag' do
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

  describe "PATCH /api/v1/tags/:id" do
    let!(:other_user) { FactoryBot.create(:user) }
    let!(:tag) { FactoryBot.create(:tag, user:) }

    let(:new_name) { 'New name' }

    let(:url) { "/api/v1/tags/#{tag.id}" }
    let(:wrong_url) { '/api/v1/tags/456' }

    context 'when logged in' do
      before do
        login_with_api(user)

        patch(
          url,
          headers: {
            'Authorization':  response.headers['Authorization']
          },
          params: {
            tag: {
              name: new_name
            }
          }
        )
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the tag' do
        expect(json_body['tag']['name']).to eq(new_name)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        patch url, params: {
          tag: {
            name: new_name
          }
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when tag does not exist' do
      before do
        login_with_api(user)

        patch(
          wrong_url,
          headers: {
            'Authorization':  response.headers['Authorization']
          },
          params: {
            tag: {
              name: new_name
            }
          }
        )
      end

      it 'returns 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user does not own tag' do
      before do
        login_with_api(other_user)

        patch(
          url,
          headers: {
            'Authorization':  response.headers['Authorization']
          },
          params: {
            tag: {
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
