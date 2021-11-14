# frozen_string_literal: true

RSpec.describe UserSessions::CreateService do
  subject(:service) { described_class }

  context 'valid parameters' do
    let!(:user) { Fabricate(:user) }

    it 'creates a new session' do
      expect { service.call(SecureRandom.uuid, user.gid) }.
        to change { user.reload.sessions.count }.from(0).to(1)
    end

    it 'assigns session' do
      result = service.call(SecureRandom.uuid, user.gid)

      expect(result.session).to be_kind_of(UserSession)
    end

    it 'assigns user' do
      result = service.call(SecureRandom.uuid, user.gid)

      expect(result.user).to be_kind_of(User)
    end
  end

  context 'invalid parameters' do
    context 'with missing gid' do
      let!(:user) { Fabricate(:user) }

      it 'does not create session' do
        expect { service.call(nil, user.gid) }.
          not_to change(UserSession, :count)
      end

      it 'adds an error' do
        result = service.call(nil, user.gid)

        expect(result).to be_failure
        expect(result.errors).to include([:gid, ["Gid cannot be blank"]])
      end
    end

    context 'with missing user_gid' do
      let!(:user) { Fabricate(:user) }

      it 'does not create session' do
        expect { service.call(SecureRandom.uuid, nil) }.
          not_to change(UserSession, :count)
      end

      it 'adds an error' do
        result = service.call(SecureRandom.uuid, nil)

        expect(result).to be_failure
        expect(result.errors).to include('User for this session is not found')
      end
    end
  end
end
