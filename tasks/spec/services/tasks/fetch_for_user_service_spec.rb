# frozen_string_literal: true

RSpec.describe Tasks::FetchForUserService do
  subject(:service) { described_class }

  context 'when user is authenticated' do
    let(:session) { Fabricate(:user_session) }
    let!(:user_task) { Fabricate(:task, user: session.user) }

    before { Fabricate.times(2, :task) }

    it 'assign tasks' do
      result = service.call(session.gid)

      result.tasks.each do |task|
        expect(task).to be_a(Task)
      end
    end

    it 'return task of the logged in user' do
      result = service.call(session.gid)

      expect(result.tasks.map(&:id)).to include(user_task.id)
    end
  end

  context 'when user is unauthenticated' do
    it 'does not assign a task' do
      result = service.call(SecureRandom.uuid)

      expect(result.tasks).to be_nil
    end

    it 'adds an error' do
      result = service.call(SecureRandom.uuid)

      expect(result).to be_failure
      expect(result.errors).to include('User is not authenticated')
    end
  end
end
