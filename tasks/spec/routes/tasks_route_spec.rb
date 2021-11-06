# frozen_string_literal: true

RSpec.describe Application, type: :routes do
  describe 'GET api/v1/tasks/me' do
    let(:session) { Fabricate(:user_session) }
    let!(:user_task) { Fabricate(:task, user: session.user) }
    let(:other_user) { Fabricate(:user) }
    let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
    let(:endpoint) { 'api/v1/tasks/me' }

    before do
      Fabricate.times(2, :task, user: other_user)
    end

    it 'returns a collection of tasks of the logged in user' do
      get endpoint, {}, headers

      expect(last_response.status).to eq(200)
      expect(response_body['data'].size).to eq(1)
    end
  end

  describe 'GET api/v1/tasks' do
    let(:session) { Fabricate(:user_session) }
    let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{JwtEncoder.encode({ gid: session.gid })}" } }
    let(:endpoint) { 'api/v1/tasks' }

    before do
      Fabricate.times(2, :task)
    end

    it 'returns a collection of tasks' do
      get endpoint, {}, headers

      expect(last_response.status).to eq(200)
      expect(response_body['data'].size).to eq(2)
    end
  end

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
