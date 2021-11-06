# frozen_string_literal: true

RSpec.describe UserSessions::DestroyService do
  subject(:service) { described_class }

  context 'valid parameters' do
    let!(:session) { Fabricate(:user_session) }

    it 'destroys a session' do
      expect { service.call(session.gid) }.to change(UserSession, :count).by(-1)
    end

    it 'sends an event' do
      expect(EventProducer).to receive(:send_event).with(
        topic: Settings.kafka.topics.authentication,
        event_name: 'UserLoggedOut',
        event_type: 'CUD',
        payload: {
          gid: session.gid,
        }
      )

      service.call(session.gid)
    end
  end

  context 'when gid is missing' do
    it 'adds an error' do
      result = service.call(nil)

      expect(result).to be_failure
      expect(result.errors).to include('Session with this gid does not exist')
    end
  end

  context 'when session with provided gid is missing' do
    before { Fabricate(:user_session) }

    it 'adds an error' do
      result = service.call(SecureRandom.uuid)

      expect(result).to be_failure
      expect(result.errors).to include('Session with this gid does not exist')
    end
  end
end
