# frozen_string_literal: true

RSpec.describe ErrorSerializer do
  subject(:serializer) { described_class }

  describe 'from_messages' do
    context 'with single error message' do
      let(:message) { 'Error message' }

      it 'returns errors representation' do
        expect(serializer.from_message(message)).to eq(
          errors: [
            { detail: message },
          ]
        )
      end
    end

    context 'with multiple error messages' do
      let(:messages) { ['Error message 1', 'Error message 2'] }

      it 'returns errors representation' do
        expect(serializer.from_messages(messages)).to eq(
          errors: [
            { detail: messages[0] },
            { detail: messages[1] },
          ]
        )
      end
    end

    context 'with meta' do
      let(:message) { 'Error message' }
      let(:meta) { { level: 'error' } }

      it 'returns errors representation' do
        expect(serializer.from_message(message, meta: meta)).to eq(
          errors: [
            {
              detail: message,
              meta: meta,
            },
          ]
        )
      end
    end
  end

  describe 'from_model' do
    let(:model) do
      double(
        'model',
        errors: {
          blue: ['can not be empty'],
          green: ['can not be empty', 'have not defined value'],
        }
      )
    end

    it 'returns errors representation' do
      expect(serializer.from_model(model)).to eq(
        errors: [
          {
            detail: %(can not be empty),
            source: {
              pointer: '/data/attributes/blue',
            },
          },
          {
            detail: %(can not be empty),
            source: {
              pointer: '/data/attributes/green',
            },
          },
          {
            detail: %(have not defined value),
            source: {
              pointer: '/data/attributes/green',
            },
          },
        ]
      )
    end
  end
end
