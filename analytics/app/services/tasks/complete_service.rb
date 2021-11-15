# frozen_string_literal: true

module Tasks
  class CompleteService
    prepend BasicService

    param :task_id

    def call
      @task = Task.find(id: @task_id)
      return fail_t!(:task_not_found) if @task.blank?

      @task.update(status: Task::DONE_STATUS)
    end

    private

    def fail_t!(key)
      fail!(I18n.t(key, scope: 'service.tasks.complete_service'))
    end
  end
end
