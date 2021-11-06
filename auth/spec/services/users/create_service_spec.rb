# frozen_string_literal: true

RSpec.describe Users::CreateService do
  subject(:service) { described_class }

  context 'valid parameters' do
    it 'creates a new user' do
      expect { service.call('bob', 'bob@example.com', 'developer', 'givemeatoken') }.
        to change(User, :count).from(0).to(1)
    end

    it 'assigns user' do
      result = service.call('bob', 'bob@example.com', 'developer', 'givemeatoken')

      expect(result.user).to be_kind_of(User)
    end

    it 'send and event' do
      stubbed_uuid = "5609bfb3-1a41-4f17-b095-d692e5d88409"
      allow(SecureRandom).to receive(:uuid).and_return("5609bfb3-1a41-4f17-b095-d692e5d88409")

      expect(EventProducer).to receive(:send_event).with(
        topic: Settings.kafka.topics.authentication,
        event_name: 'AccountCreated',
        event_type: 'CUD',
        payload: {
          gid: stubbed_uuid,
        }
      )

      service.call('bob', 'bob@example.com', 'developer', 'givemeatoken')
    end
  end

  context 'invalid parameters' do
    it 'does not create user' do
      expect { service.call('bob', 'bob@example.com', 'developer', '') }.
        not_to change(User, :count)
    end

    it 'assigns user' do
      result = service.call('bob', 'bob@example.com', 'developer', '')

      expect(result.user).to be_kind_of(User)
    end
  end
end
