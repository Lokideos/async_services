module KafkaApp
  module Consumers
    class Base < Karafka::BaseConsumer; end

    class AuthConsumer < Base
      def consume
        params_batch.each do |message|
          puts '-' * 80
          p message
          puts '-' * 80

          message_payload = JSON(message.raw_payload)
          message_payload_data = message_payload['data']

          case message_payload['event_name']
          when 'UserLoggedOut'
            UserSessions::DestroyService.call(message_payload_data['gid'])
          else
            p 'Unknown event'
          end
        end
      end
    end
  end

  class App < Karafka::App
    setup do |config|
      config.client_id = 'async-auth'
    end

    consumer_groups.draw do
      consumer_group :events do
        topic(:'auth-stream') { consumer KafkaApp::Consumers::AuthConsumer }
      end
    end
  end
end



