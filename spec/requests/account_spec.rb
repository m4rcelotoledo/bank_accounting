require 'rails_helper'

RSpec.describe 'AccountsController', type: :request do
  describe 'POST /accounts' do
    let(:user) { create(:user) }
    let(:invalid_params) { { cpf: user } }
    let(:valid_params) { { user_id: user.id } }

    context 'when the request is invalid' do
      before do
        post '/accounts',
             params: invalid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
        expect(json).not_to be_empty
      end
    end

    context 'when the request is valid' do
      let(:account) { User.find(user.id).account }

      before do
        post '/accounts',
             params: valid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'creates an account' do
        expect(response).to have_http_status :created
        expect(json).not_to be_empty
        expect(json['id']).to eq account.id
        expect(json['user_id']).to eq user.id
      end
    end

    context 'when the user is unauthorized' do
      before do
        post '/accounts',
             params: valid_params,
             headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
