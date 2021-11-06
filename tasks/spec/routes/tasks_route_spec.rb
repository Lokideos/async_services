# frozen_string_literal: true

RSpec.describe Application, type: :routes do
  describe 'POST api/v1/tasks/create' do
    let(:session) { Fabricate(:user_session) }
    let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
    let(:endpoint) { 'api/v1/tasks/create' }

    context 'valid parameters' do
      let!(:user) { Fabricate(:user) }
      let(:params) { { title: 'title', description: 'description', user_gid: user.gid } }

      it 'returns created status' do
        post endpoint, params, headers

        expect(last_response.status).to eq(201)
      end
    end

    context 'invalid parameters' do
      let!(:user) { Fabricate(:user) }
      let(:params) { { title: nil, description: 'description', user_gid: user.gid } }

      it 'returns an error' do
        post endpoint, params, headers

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include('detail' => 'Missing parameters in the request')
      end
    end

    context 'with bad session token' do
      let(:headers) { { 'HTTP_AUTHORIZATION' => 'Bearer bad_token' } }
      let!(:user) { Fabricate(:user) }
      let(:params) { { title: 'title', description: 'description', user_gid: user.gid } }

      it 'returns an error' do
        post endpoint, params, headers

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include('detail' => 'User is not authenticated')
      end
    end
  end
end
