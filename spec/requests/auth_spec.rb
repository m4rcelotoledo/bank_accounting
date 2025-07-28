# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  let(:user) { create(:user, password: 'password123') }

  describe 'POST /auth/login' do
    context 'with valid credentials' do
      it 'returns JWT token and user information' do
        post '/auth/login', params: {
          cpf: user.cpf,
          password: 'password123'
        }

        expect(response).to have_http_status(:ok)

        json_response = response.parsed_body
        expect(json_response).to have_key('token')
        expect(json_response).to have_key('user')
        expect(json_response['user']['cpf']).to eq(user.cpf)
        expect(json_response['user']['name']).to eq(user.name)
      end
    end

    context 'with invalid credentials' do
      it 'returns invalid credentials error' do
        post '/auth/login', params: {
          cpf: '12345678901',
          password: 'wrong_password'
        }

        expect(response).to have_http_status(:unauthorized)

        json_response = response.parsed_body
        expect(json_response['errors'][0]['detail']).to eq('Invalid credentials')
      end
    end

    context 'with non-existent user' do
      it 'returns invalid credentials error' do
        post '/auth/login', params: {
          cpf: '99999999999',
          password: 'password123'
        }

        expect(response).to have_http_status(:unauthorized)

        json_response = response.parsed_body
        expect(json_response['errors'][0]['detail']).to eq('Invalid credentials')
      end
    end
  end

  describe 'GET /auth/me' do
    let(:token) { JwtService.generate_token(user) }

    context 'with valid token' do
      it 'returns authenticated user information' do
        get '/auth/me', headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)

        json_response = response.parsed_body
        expect(json_response['user']['id']).to eq(user.id)
        expect(json_response['user']['cpf']).to eq(user.cpf)
        expect(json_response['user']['name']).to eq(user.name)
      end
    end

    context 'without token' do
      it 'returns unauthorized error' do
        get '/auth/me'

        expect(response).to have_http_status(:unauthorized)

        json_response = response.parsed_body
        expect(json_response['errors'][0]['detail']).to eq('Invalid or missing token')
      end
    end

    context 'with invalid token' do
      it 'returns unauthorized error' do
        get '/auth/me', headers: { 'Authorization' => 'Bearer invalid_token' }

        expect(response).to have_http_status(:unauthorized)

        json_response = response.parsed_body
        expect(json_response['errors'][0]['detail']).to eq('Invalid or missing token')
      end
    end
  end

  describe 'POST /auth/logout' do
    let(:token) { JwtService.generate_token(user) }

    context 'with valid token' do
      it 'returns successful logout message' do
        post '/auth/logout', headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)

        json_response = response.parsed_body
        expect(json_response['message']).to eq('Logout successful')
      end
    end

    context 'without token' do
      it 'returns unauthorized error' do
        post '/auth/logout'

        expect(response).to have_http_status(:unauthorized)

        json_response = response.parsed_body
        expect(json_response['errors'][0]['detail']).to eq('Invalid or missing token')
      end
    end
  end
end
