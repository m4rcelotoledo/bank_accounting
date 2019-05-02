require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe 'POST /users' do
    let(:cpf) { Faker::IDNumber.brazilian_citizen_number }
    let(:name) { Faker::Books::Dune.character }
    let(:password) { Faker::Internet.password }
    let(:invalid_params) { { cpf: cpf } }
    let(:valid_params) do
      {
        cpf: cpf,
        name: name,
        password: password
      }
    end

    context 'when the request is invalid' do
      before { post '/users', params: invalid_params }

      it 'creates an user' do
        # Note `json` is a custom helper to parse JSON responses
        expect(response).to have_http_status :unprocessable_entity
        expect(json).not_to be_empty
      end
    end

    context 'when the request is valid' do
      let(:id) { User.find_by(cpf: cpf).id }

      before { post '/users', params: valid_params }

      it 'creates an user' do
        expect(response).to have_http_status :created
        expect(json).not_to be_empty
        expect(json['id']).to eq id
        expect(json['cpf']).to eq cpf
        expect(json['name']).to eq name
      end
    end
  end

  describe 'GET /users' do
    context 'when returns empty' do
      before { get '/users' }

      it { expect(json).to be_empty }
      it { expect(json.size).to eq 0 }
    end

    context 'when returns users' do
      before do
        create_list(:user, 25)
        get '/users'
      end

      it { expect(json).not_to be_empty }
      it { expect(json.size).to eq 20 }
      it { expect(User.count).to eq 25 }
    end
  end

  describe 'GET /users/:id' do
    let!(:user) { create(:user) }

    before do
      get "/users/#{user_id}"
    end

    context 'when user is not found' do
      let(:user_id) { 'not_found' }

      it { expect(json).not_to be_empty }

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end

    context 'when the record exists' do
      let(:user_id) { user.id }

      it { expect(json).not_to be_empty }
      it { expect(response).to have_http_status :ok }
    end
  end
end
