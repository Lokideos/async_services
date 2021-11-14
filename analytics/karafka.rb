# frozen_string_literal: true

ENV['RAKE_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] = ENV['RAKE_ENV']
require_relative 'config/environment'

KafkaApp::App.boot!
