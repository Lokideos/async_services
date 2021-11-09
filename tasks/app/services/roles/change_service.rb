# frozen_string_literal: true

module Roles
  class ChangeService
    prepend BasicService

    param :gid
    param :role

    # Should be called only from event
    def call
      @user = User.first(gid: @gid)
      return fail!(I18n.t(:user_not_found, scope: 'service.roles.change_service')) if @user.blank?

      @user.role = role
      @user.valid? ? @user.save : fail!(@user.errors)
    end
  end
end
