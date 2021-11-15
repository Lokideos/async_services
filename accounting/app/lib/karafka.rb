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

    class TasksConsumer < Base
      def consume
        params_batch.each do |message|
          puts '-' * 80
          p message
          puts '-' * 80

          message_payload = JSON(message.raw_payload)
          message_payload_data = message_payload['data']

          case message_payload['event_name']
          when 'TaskCreated'
            Tasks::CreateService.call(
              message_payload_data['gid'],
              message_payload_data['title'],
              message_payload_data['jira_id'],
              message_payload_data['user_gid']
            )
          when 'TaskAssigned'
            Tasks::AssignService.call(
              message_payload_data['gid'],
              message_payload_data['user_gid']
            )
          else
            p 'Unknown event'
          end
        end
      end
    end
  end

  class App < Karafka::App
    setup do |config|
      config.client_id = 'async-accounting'
    end

    consumer_groups.draw do
      consumer_group :events do
        topic(:'auth-stream') { consumer KafkaApp::Consumers::AuthConsumer }
        topic(:'tasks-stream') { consumer KafkaApp::Consumers::TasksConsumer }
      end
    end
  end
end
