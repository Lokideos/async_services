# frozen_string_literal: true

RSpec.describe Application, type: :routes do
  describe 'PATCH api/v1/users/role/change' do
    let(:endpoint) { 'api/v1/roles/update' }

    context 'with valid parameters' do
      let(:session) { Fabricate(:admin_user_session) }
      let!(:user) { Fabricate(:user, role: 'developer') }
      let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
      let(:params) { { gid: user.gid, role: 'manager' } }

      it 'returns an OK status' do
        patch endpoint, params, headers

        expect(last_response.status).to eq(200)
      end

      it 'returns serialized user' do
        patch endpoint, params, headers

        expect(last_response.body).to eq(UserSerializer.new(user.reload).serializable_hash.to_json)
      end
    end

    context 'with invalid parameters' do
      let(:session) { Fabricate(:admin_user_session) }
      let!(:user) { Fabricate(:user, role: 'developer') }
      let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
      let(:params) { { gid: user.gid, role: 'bad_role' } }

      it 'returns 422 status' do
        patch endpoint, params, headers

        expect(last_response.status).to eq(422)
      end

      it 'returns an error' do
        patch endpoint, params, headers

        expect(response_body['errors']).to include(
          'detail' => 'Role can only by developer, manager or admin',
          'source' => { 'pointer' => '/data/attributes/role' }
        )
      end
    end

    context 'when jwt token is invalid' do
      let!(:user) { Fabricate(:user, role: 'developer') }
      let(:headers) { { 'HTTP_AUTHORIZATION' => 'Bearer bad_token' } }
      let(:params) { { gid: user.gid, role: 'manager' } }

      it 'returns 422 status' do
        patch endpoint, params, headers

        expect(last_response.status).to eq(422)
      end

      it 'returns an error' do
        patch endpoint, params, headers

        expect(response_body['errors']).to include('detail' => 'User is not authenticated')
      end
    end

    context 'when user is unauthorized' do
      let(:session) { Fabricate(:user_session) }
      let!(:user) { Fabricate(:user, role: 'developer') }
      let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
      let(:params) { { gid: user.gid, role: 'manager' } }

      it 'returns an error' do
        patch endpoint, params, headers

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include('detail' => 'User is not authorized for this action')
      end
    end
  end
end
