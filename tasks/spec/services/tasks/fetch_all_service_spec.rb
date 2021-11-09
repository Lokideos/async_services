# frozen_string_literal: true

RSpec.describe Tasks::FetchAllService do
  subject(:service) { described_class }

  context 'when user is authenticated' do
    let(:session) { Fabricate(:user_session) }
    let(:query_result) { 'success!' }

    before do
      allow(Task).to receive(:reverse_order).and_return(query_result)
    end

    it 'assigns tasks' do
      result = service.call(session.gid)

      expect(result.tasks).to eq(query_result)
    end
  end

  context 'when user is unauthenticated' do
    it 'does not assign user' do
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
