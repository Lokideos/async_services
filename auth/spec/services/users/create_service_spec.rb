# frozen_string_literal: true

RSpec.describe Users::CreateService do
  subject { described_class }

  context 'valid parameters' do
    it 'creates a new user' do
      expect { subject.call('bob', 'bob@example.com', 'developer', 'givemeatoken') }
        .to change(User, :count).from(0).to(1)
    end

    it 'assigns user' do
      result = subject.call('bob', 'bob@example.com', 'developer', 'givemeatoken')

      expect(result.user).to be_kind_of(User)
    end
  end

  context 'invalid parameters' do
    it 'does not create user' do
      expect { subject.call('bob', 'bob@example.com', 'developer', '') }
        .not_to change(User, :count)
    end

    it 'assigns user' do
      result = subject.call('bob', 'bob@example.com', 'developer', '')

      expect(result.user).to be_kind_of(User)
    end
  end
end
