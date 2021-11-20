# frozen_string_literal: true

module Tasks
  class CompleteService
    prepend BasicService

    param :task_id
    param :session_gid

    attr_reader :task

    def call
      if @session_gid.blank? || session.blank?
        return fail!(I18n.t(:unauthenticated, scope: 'errors'))
      end

      @task = Task.find(id: @task_id)
      return fail_t!(:not_found) if @task.blank?

      return fail!(I18n.t(:unauthorized, scope: 'errors')) if session.user.id != @task.user.id

      @task.update(status: Task::DONE_STATUS, new_status: Task::NEW_DONE_STATUS)
      produce_event
    end

    private

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.tasks,
        event_name: 'TaskCompleted',
        event_version: event_version,
        event_type: 'BE',
        payload: {
          gid: @task.gid,
        },
        type: 'tasks.TaskCompleted'
      )
    end

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'service.tasks.complete_service'))
    end

    def session
      @session ||= UserSession.find(gid: @session_gid)
    end

    def event_version
      1
    end
  end
end
