# frozen_string_literal: true

module Tasks
  class CreateService
    prepend BasicService

    param :title
    param :jira_id
    param :description
    param :user_gid
    param :session_gid

    attr_reader :task

    def call
      if @session_gid.blank? || session.blank?
        return fail!(I18n.t(:unauthenticated, scope: 'errors'))
      end

      @user = User.first(gid: @user_gid)
      return fail!(I18n.t(:user_not_found, scope: 'errors')) if @user.blank?

      @task = ::Task.new(
        title: @title,
        jira_id: @jira_id,
        description: @description,
        status: ::Task::INITIAL_STATUS,
        new_status: ::Task::NEW_INITIAL_STATUS,
      )

      if @task.valid?
        @user.add_task(@task)
        produce_event
      else
        fail!(@task.errors)
      end
    end

    private

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.tasks,
        event_name: 'TaskCreated',
        event_version: event_version,
        event_type: 'CUD',
        payload: {
          gid: @task.gid,
          title: @task.title,
          jira_id: @task.jira_id,
          user_gid: @user.gid,
        },
        type: 'tasks.TaskCreated',
      )
    end

    def event_version
      3
    end

    def session
      @session ||= UserSession.find(gid: @session_gid)
    end
  end
end
