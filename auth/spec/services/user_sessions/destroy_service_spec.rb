# frozen_string_literal: true

RSpec.describe UserSessions::DestroyService do
  subject { described_class }

  context 'valid parameters' do
    let!(:session) { Fabricate(:user_session) }

    it 'destroys a session' do
      expect { subject.call(session.gid) }.to change(UserSession, :count).by(-1)
    end
  end

  context 'when gid is missing' do
    it 'adds an error' do
      result = subject.call(nil)

      expect(result).to be_failure
      expect(result.errors).to include('Session with this gid does not exist')
    end
  end

  context 'when session with provided gid is missing' do
    before { Fabricate(:user_session) }

    it 'adds an error' do
      result = subject.call(SecureRandom.uuid)

      expect(result).to be_failure
      expect(result.errors).to include('Session with this gid does not exist')
    end
  end
end
