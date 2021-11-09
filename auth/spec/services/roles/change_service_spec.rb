# frozen_string_literal: true

RSpec.describe Roles::ChangeService do
  subject(:service) { described_class }

  let(:new_role) { 'manager' }

  context 'valid parameters' do
    let!(:user) { Fabricate(:user, email: 'bob@example.com', role: 'developer', password: 'givemeatoken') }
    let!(:session) { Fabricate(:admin_user_session) }

    it 'changes role of the user' do
      service.call(user.gid, new_role, session.gid)

      expect(user.reload.role).to eq(new_role)
    end

    it 'assigns user' do
      result = service.call(user.gid, new_role, session.gid)

      expect(result.user).to be_kind_of(User)
    end

    it 'sends an event' do
      expect(EventProducer).to receive(:send_event).with(
        topic: Settings.kafka.topics.authentication,
        event_name: 'RoleChanged',
        event_type: 'BE',
        payload: { gid: user.gid, role: new_role }
      )

      service.call(user.gid, new_role, session.gid)
    end
  end

  context 'invalid parameters' do
    context 'when performer is unauthenticated' do
      let!(:user) { Fabricate(:user, email: 'bob@example.com', role: 'developer', password: 'givemeatoken') }

      it 'does not change the role' do
        service.call(user.gid, new_role, nil)

        expect(user.reload.role).to eq('developer')
      end

      it 'adds an error' do
        result = service.call(user.gid, new_role, nil)

        expect(result).to be_failure
        expect(result.errors).to include('User is not authenticated')
      end
    end

    context 'when performer is not authorized for this action' do
      let!(:user) { Fabricate(:user, email: 'bob@example.com', role: 'developer', password: 'givemeatoken') }
      let!(:session) { Fabricate(:user_session) }

      it 'does not change the role' do
        service.call(user.gid, new_role, session.gid)

        expect(user.reload.role).to eq('developer')
      end

      it 'adds an error' do
        result = service.call(user.gid, new_role, session.gid)

        expect(result).to be_failure
        expect(result.errors).to include('User is not authorized for this action')
      end
    end

    context 'when user is not present' do
      let!(:session) { Fabricate(:admin_user_session) }

      it 'adds an error' do
        result = service.call(nil, new_role, session.gid)

        expect(result).to be_failure
        expect(result.errors).to include('User with this gid does not exist')
      end
    end

    context 'when new role is invalid' do
      let!(:user) { Fabricate(:user, email: 'bob@example.com', role: 'developer', password: 'givemeatoken') }
      let!(:session) { Fabricate(:admin_user_session) }

      it 'does not change the role' do
        service.call(user.gid, 'bad_role', session.gid)

        expect(user.reload.role).to eq('developer')
      end

      it 'adds an error' do
        result = service.call(user.gid, 'bad_role', session.gid)

        expect(result).to be_failure
        expect(result.errors).to include([:role, ["Role can only by developer, manager or admin"]])
      end
    end
  end
end
