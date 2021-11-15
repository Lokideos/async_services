# frozen_string_literal: true

module Tasks
  class AssignService
    prepend BasicService

    param :task_gid
    param :user_gid

    def call
      @user = User.first(gid: @user_gid)
      return fail!(I18n.t(:user_not_found, scope: 'errors')) if @user.blank?

      @task = Task.first(gid: @task_gid)
      return fail!(I18n.t(:task_not_found, scope: 'service.tasks.assign_service')) if @task.blank?

      @task.update(user_id: @user.id)
      Balances::WithdrawService.call(@user.id, @task.cost)
    end
  end
end
