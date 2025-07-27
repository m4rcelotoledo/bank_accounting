# frozen_string_literal: true

require 'rails_helper'

describe 'UsersController', type: :request do
  describe 'POST /users' do
    let(:cpf) { Faker::IdNumber.brazilian_citizen_number }
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
      before { post users_path, params: invalid_params }

      it 'returns status code 422' do
        expect(json[:errors].first[:status]).to eq '422'
        expect(json[:errors].first[:title]).to eq 'Unprocessable Entity'
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'when the password is less than the minimum required' do
      let(:invalid_params) do
        {
          cpf: cpf,
          name: name,
          password: '123456'
        }
      end

      before { post users_path, params: invalid_params }

      it 'returns status code 422' do
        expect(json[:errors].first[:status]).to eq '422'
        expect(json[:errors].first[:title]).to eq 'Unprocessable Entity'
        expect(response).to have_http_status :unprocessable_entity
        expect(response.body).to match(/(minimum is 8 characters)/)
      end
    end

    context 'when the request is valid' do
      let(:id) { User.find_by(cpf: cpf).id }

      before { post users_path, params: valid_params }

      it 'creates an user' do
        expect(response).to have_http_status :created
        expect(json).not_to be_empty
        expect(json[:id]).to eq id
        expect(json[:cpf]).to eq cpf
        expect(json[:name]).to eq name
      end
    end
  end

  describe 'GET /users' do
    context 'when the user is unauthorized' do
      before do
        get users_path,
            headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
        expect(json[:errors].first[:status]).to eq '401'
        expect(json[:errors].first[:title]).to eq 'Unauthorized'
      end
    end

    context 'when returns users' do
      let(:user) { create(:user) }

      before do
        create_list(:user, 25)
        get users_path, headers: basic_credentials(user.cpf, user.password)
      end

      it { expect(json).not_to be_empty }
      it { expect(json.size).to eq 20 }
      it { expect(User.count).to eq 26 }
    end
  end

  describe 'GET /users/:id' do
    let!(:user) { create(:user) }

    before do
      get user_path(user_id),
          headers: basic_credentials(user.cpf, user.password)
    end

    context 'when user is not found' do
      let(:user_id) { 'not_found' }

      it { expect(json).not_to be_empty }

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
        expect(json[:errors].first[:status]).to eq '404'
        expect(json[:errors].first[:title]).to eq 'Not Found'
      end

      it 'returns a not found message' do
        expect(json[:errors].first[:detail]).to match(/Couldn't find User/)
      end
    end

    context 'when the record exists' do
      let(:user_id) { user.id }

      it { expect(json).not_to be_empty }
      it { expect(response).to have_http_status :ok }
    end
  end
end
