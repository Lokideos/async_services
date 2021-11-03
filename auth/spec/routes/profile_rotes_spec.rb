# frozen_string_literal: true

RSpec.describe Application, type: :routes do
  describe 'GET api/v1/me' do
    let(:user) { Fabricate(:user, email: 'bob@example.com', password: 'givemeatoken') }
    let(:session) { Fabricate(:user_session, user: user) }
    let(:endpoint) { 'api/v1/me' }

    context 'when jwt token is missing' do
      it 'returns an error' do
        get endpoint, {}, {}

        expect(last_response.status).to eq(403)
      end
    end

    context 'when jwt token is invalid' do
      let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer invalid" } }

      it 'returns an error' do
        get endpoint, {}, headers

        expect(last_response.status).to eq(403)
      end
    end

    context 'when jwt token is valid' do
      let(:user) { Fabricate(:user, email: 'bob@example.com', password: 'givemeatoken') }
      let(:session) { Fabricate(:user_session, user: user) }
      let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode(gid: session.gid)}" } }

      it 'returns created status' do
        get endpoint, {}, headers

        expect(last_response.status).to eq(200)
        expect(response_body.to_json).to eq UserSerializer.new(user).serializable_hash.to_json
      end
    end
  end
end
