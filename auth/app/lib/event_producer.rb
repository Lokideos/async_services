# frozen_string_literal: true

module EventProducer
  class ForbiddenEventTypeError < StandardError; end

  module_function

  ALLOWED_EVENT_TYPES = %w(BE CUD).freeze

  def send_event(topic:, event_name:, event_type:, payload:)
    raise ForbiddenEventTypeError unless ALLOWED_EVENT_TYPES.include? event_type

    producer = WaterDrop::Producer.new do |config|
      config.deliver = PRODUCER_SETTINGS[:deliver]
      config.kafka = PRODUCER_SETTINGS[:kafka]
    end

    producer.produce_sync(payload: serialized_payload(event_name, event_type, payload), topic: topic)
  end

  def serialized_payload(event_name, event_type, event_data)
    {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: Settings.app.name,
      event_name: event_name,
      event_type: event_type,
      data: event_data,
    }.to_json
  end
end
