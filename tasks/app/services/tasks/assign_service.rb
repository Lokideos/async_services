# frozen_string_literal: true

module Tasks
  class AssignService
    prepend BasicService

    param :session_gid

    def call
      if @session_gid.blank? || session.blank?
        return fail!(I18n.t(:unauthenticated, scope: 'errors'))
      end

      @user = session.user
      return fail!(I18n.t(:user_not_found, scope: 'service.tasks.create_service')) if @user.blank?

      return fail!(I18n.t(:unauthorized, scope: 'errors')) unless %w(admin manager).include? @user.role

      user_developer_ids = User.developer_ids
      Task.non_closed_tasks.each do |task|
        next if user_developer_ids.size == 1

        task.update(user_id: (user_developer_ids - [task.user_id]).sample)
      end
    end

    private

    def session
      @session ||= UserSession.find(gid: @session_gid)
    end
  end
end
