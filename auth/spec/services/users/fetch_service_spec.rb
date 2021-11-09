# frozen_string_literal: true

RSpec.describe Users::FetchService do
  subject(:service) { described_class }

  context 'valid parameters' do
    let(:session) { Fabricate(:user_session) }

    it 'assigns user' do
      result = service.call(session.gid)

      expect(result.user).to eq(session.user)
    end
  end

  context 'invalid parameters' do
    it 'does not assign user' do
      result = service.call(SecureRandom.uuid)

      expect(result.user).to be_nil
    end

    it 'adds an error' do
      result = service.call(SecureRandom.uuid)

      expect(result).to be_failure
      expect(result.errors).to include('User not found')
    end
  end
end
