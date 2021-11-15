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
          when 'AccountCreated'
            Users::CreateService.call(message_payload_data['gid'], message_payload_data['role'])
          when 'AccountDeleted'
            Users::DestroyService.call(message_payload_data['gid'])
          when 'UserAuthenticated'
            UserSessions::CreateService.call(message_payload_data['gid'], message_payload_data['user_gid'])
          when 'UserLoggedOut'
            UserSessions::DestroyService.call(message_payload_data['gid'])
          when 'RoleChanged'
            Roles::ChangeService.call(message_payload_data['gid'], message_payload_data['role'])
          else
            p 'Unknown event'
          end
        end
      end
    end

    class AccountingConsumer < Base
      def consume
        params_batch.each do |message|
          puts '-' * 80
          p message
          puts '-' * 80

          message_payload = JSON(message.raw_payload)
          message_payload_data = message_payload['data']

          case message_payload['event_name']
          when 'Deposit'
            Balances::ChangeService.call(message_payload_data['user_gid'], message_payload_data['balance_amount'])
          when 'Withdraw'
            Balances::ChangeService.call(message_payload_data['user_gid'], message_payload_data['balance_amount'])
          when 'Nullify'
            Balances::ChangeService.call(message_payload_data['user_gid'], 0)
          else
            p 'Unknown event'
          end
        end
      end

    end
  end

  class App < Karafka::App
    setup do |config|
      config.client_id = 'async-analytics'
    end

    consumer_groups.draw do
      consumer_group :events do
        topic(:'auth-stream') { consumer KafkaApp::Consumers::AuthConsumer }
        topic(:'accounting-stream') { consumer KafkaApp::Consumers::AccountingConsumer }
        # topic(:'tasks-stream') { consumer KafkaApp::Consumers::AuthConsumer }
      end
    end
  end
end



