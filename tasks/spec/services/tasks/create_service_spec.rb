# frozen_string_literal: true

RSpec.describe Tasks::CreateService do
  subject(:service) { described_class }

  context 'valid parameters' do
    let!(:user) { Fabricate(:user) }
    let!(:session) { Fabricate(:user_session) }

    it 'creates a new task' do
      expect { service.call('title', 'description', user.gid, session.gid) }.
        to change(Task, :count).from(0).to(1)
    end

    it 'assigns task' do
      result = service.call('title', 'description', user.gid, session.gid)

      expect(result.task).to be_kind_of(Task)
    end

    it 'send an event' do
      stubbed_uuid = "5609bfb3-1a41-4f17-b095-d692e5d88409"
      allow(SecureRandom).to receive(:uuid).and_return("5609bfb3-1a41-4f17-b095-d692e5d88409")

      expect(EventProducer).to receive(:send_event).with(
        topic: Settings.kafka.topics.tasks,
        event_name: 'TaskCreated',
        event_type: 'CUD',
        payload: {
          gid: stubbed_uuid,
        }
      )

      service.call('title', 'description', user.gid, session.gid)
    end
  end

  context 'invalid parameters' do
    let!(:user) { Fabricate(:user) }
    let!(:session) { Fabricate(:user_session) }

    it 'does not create a task' do
      expect { service.call(nil, 'description', user.gid, session.gid) }.
        not_to change(Task, :count)
    end

    it 'assigns task' do
      result = service.call(nil, 'description', user.gid, session.gid)

      expect(result.task).to be_kind_of(Task)
    end
  end

  context 'when session_gid is not present' do
    let!(:user) { Fabricate(:user) }

    it 'does not create a task' do
      expect { service.call('title', 'description', user.gid, nil) }.
        not_to change(Task, :count)
    end

    it 'returns an error' do
      result = service.call('title', 'description', user.gid, nil)

      expect(result).to be_failure
      expect(result.errors).to include('User is not authenticated')
    end
  end

  context 'when user for provided user_gid is not present' do
    let!(:session) { Fabricate(:user_session) }

    it 'does not create a task' do
      expect { service.call('title', 'description', nil, session.gid) }.
        not_to change(Task, :count)
    end

    it 'returns an error' do
      result = service.call('title', 'description', nil, session.gid)

      expect(result).to be_failure
      expect(result.errors).to include('User for this session is not found')
    end
  end
end
