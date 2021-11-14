# frozen_string_literal: true

module EventProducer
  class ForbiddenEventTypeError < StandardError; end

  module_function

  ALLOWED_EVENT_TYPES = %w(BE CUD).freeze

  def send_event(topic:, event_name:, event_type:, event_version: 1, payload:)
    raise ForbiddenEventTypeError unless ALLOWED_EVENT_TYPES.include? event_type

    WaterDrop::SyncProducer.call(serialized_payload(event_name, event_type, payload, event_version), topic: topic)
  end

  def serialized_payload(event_name, event_type, event_data, event_version)
    {
      event_id: SecureRandom.uuid,
      event_version: event_version,
      event_time: Time.now.to_s,
      producer: Settings.app.name,
      event_name: event_name,
      event_type: event_type,
      data: event_data,
    }.to_json
  end
end
