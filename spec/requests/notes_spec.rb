require 'rails_helper'

RSpec.describe "Notes", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe "GET /index" do
    let(:notes_size) { 5 }
    let!(:notes) { FactoryBot.create_list(:note, notes_size, user:) }

    let(:index_url) { '/api/v1/notes' }

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

      it 'returns user notes' do
        expect(json_body['notes'].size).to eq(notes_size)
      end
    end

    context 'When Authorization header is not passed' do
      it 'returns 401' do
        get index_url

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /notes/:id" do
    let(:title) { 'Note title' }
    let(:content) { 'Note Content' }
    let!(:note) { FactoryBot.create(:note, title:, content:, user:) }
    let!(:other_user) { FactoryBot.create(:user) }

    let(:url) { "/api/v1/notes/#{note.id}" }

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

      it 'returns the correct note' do
        expect(json_body['note']['title']).to eq(title)
        expect(json_body['note']['content']).to eq(content)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        get url

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when note does no belong to user' do
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

  describe 'POST /api/v1/notes' do
    let(:url) { '/api/v1/notes' }

    context 'when logged in' do
      before do
        login_with_api(user)

        post(
          url,
          headers: { 'Authorization': response.headers['Authorization'] },
          params: {
            note: {
              title: 'title',
              content: 'content '
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
          note: {
            title: 'title',
            content: 'content'
          }
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when title is missing' do
      before do
        login_with_api(user)

        post(
          url,
          headers: { 'Authorization': response.headers['Authorization'] },
          params: {
            note: {
              title: '',
              content: 'content '
            }
          }
        )
      end

      it 'returns 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/notes/:id" do
    let!(:other_user) { FactoryBot.create(:user) }
    let!(:note) { FactoryBot.create(:note, user:) }
    let(:url) { "/api/v1/notes/#{note.id}" }
    let(:wrong_url) { '/api/v1/notes/456' }

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

    context 'when note does not exist' do
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


    context 'when user does not own note' do
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

  describe "PATCH /api/v1/notes/:id" do
    let!(:other_user) { FactoryBot.create(:user) }
    let!(:note) { FactoryBot.create(:note, user:) }

    let(:new_title) { 'New title' }

    let(:url) { "/api/v1/notes/#{note.id}" }
    let(:wrong_url) { '/api/v1/notes/456' }

    context 'when logged in' do
      before do
        login_with_api(user)

        patch(
          url,
          headers: {
            'Authorization':  response.headers['Authorization']
          },
          params: {
            note: {
              title: new_title
            }
          }
        )
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the note' do
        expect(json_body['note']['title']).to eq(new_title)
      end
    end

    context 'when unauthenticated' do
      it 'returns 401' do
        patch url, params: {
          note: {
            title: new_title
          }
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when note does not exist' do
      before do
        login_with_api(user)

        patch(
          wrong_url,
          headers: {
            'Authorization':  response.headers['Authorization']
          },
          params: {
            note: {
              title: new_title
            }
          }
        )
      end

      it 'returns 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user does not own note' do
      before do
        login_with_api(other_user)

        patch(
          url,
          headers: {
            'Authorization':  response.headers['Authorization']
          },
          params: {
            note: {
              title: new_title
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
