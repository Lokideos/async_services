# frozen_string_literal: true

RSpec.describe Application, type: :routes do
  describe 'POST api/v1/auth/signin' do
    let(:endpoint) { 'api/v1/auth/signin' }

    context 'missing parameters' do
      let(:params) { { email: 'bob@example.com', password: '1' } }

      it 'returns an error' do
        post endpoint, params

        expect(last_response.status).to eq(401)
      end
    end

    context 'invalid parameters' do
      let(:params) { { email: 'bob@example.com', password: 'invalid' } }

      it 'returns an error' do
        post endpoint, params

        expect(last_response.status).to eq(401)
        expect(response_body['errors']).to include('detail' => 'Session cannot be created')
      end
    end

    context 'valid parameters' do
      let(:token) { 'jwt_token' }
      let(:params) { { email: 'bob@example.com', password: 'givemeatoken' } }

      before do
        Fabricate(:user, email: 'bob@example.com', password: 'givemeatoken')

        allow(JWT).to receive(:encode).and_return(token)
      end

      it 'returns created status' do
        post endpoint, params

        expect(last_response.status).to eq(201)
        expect(response_body['meta']).to eq('token' => token)
      end
    end
  end
end
