# frozen_string_literal: true

module Tasks
  class CreateService
    prepend BasicService

    param :gid
    param :title
    param :jira_id
    param :user_gid

    def call
      @user = User.first(gid: @user_gid)
      return fail!(I18n.t(:user_not_found, scope: 'errors')) if @user.blank?

      @task = ::Task.new(
        gid: @gid,
        title: @title,
        jira_id: @jira_id,
        status: ::Task::INITIAL_STATUS,
        cost: initial_cost,
        compensation: initial_compensation
      )

      if @task.valid?
        @user.add_task(@task)
        Balances::WithdrawService.call(@user.id, @task.cost)
      else
        fail!(@task.errors)
      end
    end

    private

    def produce_event
      EventProducer.send_event(
        topic: Settings.kafka.topics.accounting,
        event_name: 'CostAssigned',
        event_version: event_version,
        event_type: 'CUD',
        payload: {
          task_gid: @task.gid,
          task_title: @task.title,
          task_cost: @task.cost,
          task_compensation: @task.compensation,
        },
        type: 'accounting.CostAssigned'
      )
    end

    def event_version
      1
    end

    def initial_cost
      rand(10..20).to_d
    end

    def initial_compensation
      rand(20..40).to_d
    end
  end
end
