# frozen_string_literal: true

module Tasks
  class CreateService
    prepend BasicService

    param :title
    param :description
    param :user_gid
    param :session_gid

    attr_reader :task

    def call
      if @session_gid.blank? || session.blank?
        return fail!(I18n.t(:unauthenticated, scope: 'errors'))
      end

      @user = User.first(gid: @user_gid)
      return fail!(I18n.t(:user_not_found, scope: 'service.tasks.create_service')) if @user.blank?

      @task = ::Task.new(title: @title, description: @description, status: ::Task::INITIAL_STATUS)

      @task.valid? ? @user.add_task(@task) : fail!(@task.errors)
    end

    private

    def session
      @session ||= UserSession.find(gid: @session_gid)
    end
  end
end
