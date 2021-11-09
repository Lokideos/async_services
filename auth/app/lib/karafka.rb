module KafkaApp
  module Consumers
    class Base < Karafka::BaseConsumer; end

    class AuthConsumer < Base
      def consume
        params_batch.each do |message|
          puts '-' * 80
          p message
          puts '-' * 80

          case message['event_name']
          when 'UserLoggedOut'
            UserSessions::DestroyService.call(message.payload['gid'])
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



