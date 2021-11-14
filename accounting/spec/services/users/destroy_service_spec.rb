# frozen_string_literal: true

RSpec.describe Users::DestroyService do
  subject(:service) { described_class }

  context 'valid parameters' do
    let!(:user) { Fabricate(:user) }

    it 'destroys user' do
      expect { service.call(user.gid) }.to change(User, :count).by(-1)
    end
  end

  context 'invalid parameters' do
    it 'does not create user' do
      expect { service.call(nil) }.not_to change(User, :count)
    end
  end
end
