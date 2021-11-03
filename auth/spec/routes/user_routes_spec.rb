# frozen_string_literal: true

RSpec.describe Application, type: :routes do
  describe 'POST api/v1/auth/signup' do
    let(:endpoint) { 'api/v1/auth/signup' }

    context 'missing parameters' do
      let(:params) { { name: 'bob', email: 'bob@example.com', password: '' } }

      it 'returns an error' do
        post endpoint, params

        expect(last_response.status).to eq(422)
      end
    end

    context 'invalid parameters' do
      let(:params) { { name: 'b.o.b', email: 'bob@example.com', password: 'givemeatoken' } }
      it 'returns an error' do
        post endpoint, params

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include(
          {
            'detail' => 'Use only letters, numbers and low dash for the name',
            'source' => {
              'pointer' => '/data/attributes/name'
            }
          }
        )
      end
    end

    context 'valid parameters' do
      let(:params) { { name: 'bob', email: 'bob@example.com', password: 'givemeatoken' } }

      it 'returns created status' do
        post endpoint, params

        expect(last_response.status).to eq(201)
      end
    end
  end
end
