# frozen_string_literal: true

RSpec.describe Payments::CreateService do
  subject(:service) { described_class }

  let(:amount) { 100 }

  before { allow(WaterDrop::SyncProducer).to receive(:call) }

  context 'valid parameters' do
    let(:user) { Fabricate(:user) }

    it 'process the payment' do
      expect { service.call(user.id, amount) }.to output.to_stdout
    end

    it 'produces an event' do
      expect(EventProducer).to receive(:send_event)

      service.call(user.id, amount)
    end
  end

  context 'invalid parameters' do
    context 'with missing user id' do
      it 'does not process payment' do
        expect { service.call(nil, amount) }.not_to output.to_stdout
      end

      it 'adds an error' do
        result = service.call(nil, amount)

        expect(result).to be_failure
        expect(result.errors).to include('User was not provided')
      end

      it 'does not produce an event' do
        expect(EventProducer).not_to receive(:send_event)

        service.call(nil, amount)
      end
    end
  end
end
