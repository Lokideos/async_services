# frozen_string_literal: true

RSpec.describe Application, type: :routes do
  describe 'GET api/v1/users' do
    let(:session) { Fabricate(:user_session) }
    let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
    let(:endpoint) { 'api/v1/users' }

    before do
      Fabricate.times(2, :user)
    end

    it 'returns a collection of ads' do
      get endpoint, {}, headers

      expect(last_response.status).to eq(200)
      # fabricated users + 1 from session
      expect(response_body['data'].size).to eq(3)
    end
  end
end
