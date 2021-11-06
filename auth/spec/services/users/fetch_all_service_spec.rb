# frozen_string_literal: true

RSpec.describe Users::FetchAllService do
  subject { described_class }

  context 'when user is authenticated' do
    let(:session) { Fabricate(:user_session) }
    let(:query_result) { 'success!' }

    before do
      allow(User).to receive(:reverse_order).and_return(query_result)
    end

    it 'assigns users' do
      result = subject.call(session.gid)

      expect(result.users).to eq(query_result)
    end
  end

  context 'when user is unauthenticated' do
    it 'does not assign user' do
      result = subject.call(SecureRandom.uuid)

      expect(result.users).to be_nil
    end

    it 'adds an error' do
      result = subject.call(SecureRandom.uuid)

      expect(result).to be_failure
      expect(result.errors).to include('User is not authenticated')
    end
  end
end
