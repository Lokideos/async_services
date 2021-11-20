# frozen_string_literal: true

RSpec.describe Tasks::CompleteService, type: :service do
  subject(:service) { described_class }

  let(:session) { Fabricate(:user_session) }
  let!(:task) { Fabricate(:task, status: Task::INITIAL_STATUS, user: session.user) }

  context 'valid parameters' do
    it "updates task status to 'done'" do
      service.call(task.id, session.gid)

      expect(task.reload.status).to eq Task::DONE_STATUS
    end

    it 'assigns task' do
      result = service.call(task.id, session.gid)

      expect(result.task).to be_kind_of(Task)
    end

    it 'sends an event' do
      expect(EventProducer).to receive(:send_event).with(
        topic: Settings.kafka.topics.tasks,
        event_name: 'TaskCompleted',
        event_version: 1,
        event_type: 'BE',
        payload: {
          gid: task.gid,
        },
        type: 'tasks.TaskCompleted'
      )

      service.call(task.id, session.gid)
    end
  end

  context 'invalid parameters' do
    context 'task with given task_id does not exist' do
      let(:bad_task_id) { 0 }

      it 'adds an error' do
        result = service.call(bad_task_id, session.gid)

        expect(result).to be_failure
        expect(result.errors).to include('Task with this id does not exist')
      end
    end

    context 'user is trying to close another users task' do
      let(:bad_user_id) { 0 }
      let(:another_task) { Fabricate(:task) }

      it 'adds an error' do
        result = service.call(another_task.id, session.gid)

        expect(result).to be_failure
        expect(result.errors).to include('User is not authorized for this action')
      end
    end
  end
end
