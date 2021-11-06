# frozen_string_literal: true

PRODUCER_SETTINGS = {
  deliver: !(Application.environment == :test),
  kafka: {
    'bootstrap.servers': 'localhost:9092',
    'request.required.acks': 1,
  }.freeze,
}.freeze
