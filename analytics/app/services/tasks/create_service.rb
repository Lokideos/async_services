# frozen_string_literal: true

module Tasks
  class CreateService
    prepend BasicService

    param :gid
    param :title
    param :cost

    def call
      @task = ::Task.new(
        gid: @gid,
        title: @title,
        status: ::Task::INITIAL_STATUS,
        cost: @cost
      )

      @task.valid? ? @task.save : fail!(@task.errors)
    end
  end
end
