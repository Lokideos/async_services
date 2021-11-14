# frozen_string_literal: true

RSpec.describe Roles::ChangeService do
  subject(:service) { described_class }

  let(:new_role) { 'manager' }

  context 'valid parameters' do
    let!(:user) { Fabricate(:user, role: 'developer') }

    it 'changes role of the user' do
      service.call(user.gid, new_role)

      expect(user.reload.role).to eq(new_role)
    end
  end

  context 'invalid parameters' do
    context 'when user is not present' do
      it 'adds an error' do
        result = service.call(nil, new_role)

        expect(result).to be_failure
        expect(result.errors).to include('User not found')
      end
    end

    context 'when new role is invalid' do
      let!(:user) { Fabricate(:user, role: 'developer') }
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
