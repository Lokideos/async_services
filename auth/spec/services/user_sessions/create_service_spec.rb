# frozen_string_literal: true

RSpec.describe UserSessions::CreateService do
  subject { described_class }

  context 'valid parameters' do
    let!(:user) { Fabricate(:user, email: 'bob@example.com', password: 'givemeatoken') }

    it 'creates a new session' do
      expect { subject.call('bob@example.com', 'givemeatoken') }.
        to change { user.reload.sessions.count }.from(0).to(1)
    end

    it 'assigns session' do
      result = subject.call('bob@example.com', 'givemeatoken')

      expect(result.session).to be_kind_of(UserSession)
    end

    it 'assigns user' do
      result = subject.call('bob@example.com', 'givemeatoken')

      expect(result.user).to be_kind_of(User)
    end

    context 'when session is already present for user' do
      before { Fabricate(:user_session, user: user) }

      it 'does not create a new session' do
        expect { subject.call('bob@example.com', 'givemeatoken') }.
          not_to change { user.reload.sessions.count }
      end

      it 'assigns session' do
        result = subject.call('bob@example.com', 'givemeatoken')

        expect(result.session).to be_kind_of(UserSession)
      end

      it 'assigns user' do
        result = subject.call('bob@example.com', 'givemeatoken')

        expect(result.user).to be_kind_of(User)
      end
    end
  end

  context 'missing user' do
    it 'does not create session' do
      expect { subject.call('bob@example.com', 'givemeatoken') }.
        not_to change(UserSession, :count)
    end

    it 'adds an error' do
      result = subject.call('bob@example.com', 'givemeatoken')

      expect(result).to be_failure
      expect(result.errors).to include('Session cannot be created')
    end
  end

  context 'invalid password' do
    let!(:user) { Fabricate(:user, email: 'bob@example.com', password: 'givemeatoken') }

    it 'does not create session' do
      expect { subject.call('bob@example.com', 'invalid') }.
        not_to change(UserSession, :count)
    end

    it 'adds an error' do
      result = subject.call('bob@example.com', 'invalid')

      expect(result).to be_failure
      expect(result.errors).to include('Session cannot be created')
    end
  end
end
