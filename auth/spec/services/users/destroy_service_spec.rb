# frozen_string_literal: true

RSpec.describe Users::DestroyService do
  subject(:service) { described_class }

  context 'valid parameters' do
    let!(:user) { Fabricate(:user) }
    let!(:session) { Fabricate(:admin_user_session) }

    it 'destroys user' do
      expect { service.call(user.id, session.gid) }.to change(User, :count).by(-1)
    end

    it 'sends an event' do
      expect(EventProducer).to receive(:send_event).with(
        topic: Settings.kafka.topics.authentication,
        event_name: 'AccountDeleted',
        event_version: 1,
        event_type: 'CUD',
        payload: {
          gid: user.gid,
        },
        type: 'auth.AccountDeleted',
      )

      service.call(user.id, session.gid)
    end
  end

  context 'invalid parameters' do
    context 'when performer is unauthenticated' do
      let!(:user) { Fabricate(:user) }

      it 'does not destroy the user' do
        expect { service.call(user.id, nil) }.not_to change(User, :count)
      end

      it 'adds an error' do
        result = service.call(user.id, nil)

        expect(result).to be_failure
        expect(result.errors).to include('User is not authenticated')
      end
    end

    context 'when performer is not authorized for this action' do
      let!(:user) { Fabricate(:user, email: 'bob@example.com', role: 'developer', password: 'givemeatoken') }
      let!(:session) { Fabricate(:user_session) }

      it 'does not destroy the user' do
        expect { service.call(user.id, session.gid) }.not_to change(User, :count)
      end

      it 'adds an error' do
        result = service.call(user.id, session.gid)

        expect(result).to be_failure
        expect(result.errors).to include('User is not authorized for this action')
      end
    end

    context 'when user is not present' do
      let!(:session) { Fabricate(:admin_user_session) }

      it 'adds an error' do
        result = service.call(nil, session.gid)

        expect(result).to be_failure
        expect(result.errors).to include('User not found')
      end
    end
  end
end
