# frozen_string_literal: true

RSpec.describe Application, type: :routes do
  describe 'GET api/v1/users' do
    let(:session) { Fabricate(:user_session) }
    let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
    let(:endpoint) { 'api/v1/users' }

    before do
      Fabricate.times(2, :user)
    end

    it 'returns a collection of users' do
      get endpoint, {}, headers

      expect(last_response.status).to eq(200)
      # fabricated users + 1 from session
      expect(response_body['data'].size).to eq(3)
    end
  end

  describe 'DELETE api/v1/users/destroy' do
    let(:endpoint) { 'api/v1/users/destroy' }

    context 'with valid params' do
      let(:session) { Fabricate(:admin_user_session) }
      let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
      let(:params) { { id: user.id } }
      let!(:user) { Fabricate(:user) }

      it 'destroys the user' do
        delete endpoint, params, headers

        expect(last_response.status).to eq(200)
      end
    end

    context 'missing parameters' do
      let(:session) { Fabricate(:admin_user_session) }
      let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
      let(:params) { {} }

      it 'returns an error' do
        delete endpoint, params, headers

        expect(last_response.status).to eq(422)
      end
    end

    context 'when jwt token is invalid' do
      let!(:user) { Fabricate(:user, role: 'developer') }
      let(:headers) { { 'HTTP_AUTHORIZATION' => 'Bearer bad_token' } }
      let(:params) { { id: user.id } }

      it 'returns an error' do
        delete endpoint, params, headers

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include('detail' => 'User is not authenticated')
      end
    end

    context 'when user is unauthorized' do
      let(:session) { Fabricate(:user_session) }
      let!(:user) { Fabricate(:user, role: 'developer') }
      let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
      let(:params) { { id: user.id } }

      it 'returns an error' do
        delete endpoint, params, headers

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include('detail' => 'User is not authorized for this action')
      end
    end
  end
end
