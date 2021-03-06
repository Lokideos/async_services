# frozen_string_literal: true

RSpec.describe Users::CreateService do
  subject(:service) { described_class }

  context 'valid parameters' do
    it 'creates a new user' do
      expect { service.call(SecureRandom.uuid, 'developer') }.
        to change(User, :count).from(0).to(1)
    end

    it 'assigns user' do
      result = service.call(SecureRandom.uuid, 'developer')

      expect(result.user).to be_kind_of(User)
    end
  end

  context 'invalid parameters' do
    it 'does not create user' do
      expect { service.call(SecureRandom.uuid, 'bad_role') }.
        not_to change(User, :count)
    end

    it 'assigns user' do
      result = service.call(SecureRandom.uuid, 'developer')

      expect(result.user).to be_kind_of(User)
    end
  end
end
