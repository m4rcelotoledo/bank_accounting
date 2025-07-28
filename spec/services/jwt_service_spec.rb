# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtService do
  let(:user) { create(:user, cpf: '12345678901') }

  describe '.generate_token' do
    it 'generates a valid JWT token' do
      token = described_class.generate_token(user)

      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3) # JWT has 3 parts
    end

    it 'includes user information in the token' do
      token = described_class.generate_token(user)
      decoded = described_class.decode(token)

      expect(decoded['user_id']).to eq(user.id)
      expect(decoded['cpf']).to eq(user.cpf)
      expect(decoded['exp']).to be > Time.current.to_i
    end
  end

  describe '.decode' do
    context 'with valid token' do
      it 'decodes the token correctly' do
        token = described_class.generate_token(user)
        decoded = described_class.decode(token)

        expect(decoded['user_id']).to eq(user.id)
        expect(decoded['cpf']).to eq(user.cpf)
      end
    end

    context 'with invalid token' do
      it 'returns nil' do
        result = described_class.decode('invalid_token')
        expect(result).to be_nil
      end
    end

    context 'with expired token' do
      it 'returns nil' do
        payload = {
          user_id: user.id,
          cpf: user.cpf,
          exp: 1.hour.ago.to_i
        }
        token = described_class.encode(payload)

        result = described_class.decode(token)
        expect(result).to be_nil
      end
    end
  end

  describe '.encode' do
    it 'encodes payload into JWT token' do
      payload = { user_id: 1, cpf: '12345678901' }
      token = described_class.encode(payload)

      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3)
    end
  end

  describe '.secret_key' do
    context 'when in development environment' do
      before do
        allow(Rails.env).to receive(:production?).and_return(false)
        allow(Rails.application.credentials).to receive(:secret_key_base).and_return(nil)
      end

      it 'returns fallback secret key when credentials are not available' do
        expect(described_class.secret_key).to eq('fallback_secret_key_for_jwt_development')
      end

      it 'returns credentials secret key when available' do
        allow(Rails.application.credentials).to receive(:secret_key_base).and_return('test_secret_key')
        expect(described_class.secret_key).to eq('test_secret_key')
      end
    end

    context 'when in production environment' do
      before do
        allow(Rails.env).to receive(:production?).and_return(true)
      end

      it 'returns credentials secret key when available' do
        allow(Rails.application.credentials).to receive(:secret_key_base).and_return('production_secret_key')
        expect(described_class.secret_key).to eq('production_secret_key')
      end

      it 'raises error when credentials are not available' do
        allow(Rails.application.credentials).to receive(:secret_key_base).and_return(nil)
        expect { described_class.secret_key }.to raise_error('Missing secret_key_base in credentials for production!')
      end
    end
  end
end
