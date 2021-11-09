# frozen_string_literal: true

module Users
  class DestroyService
    prepend BasicService

    param :gid

    attr_reader :user

    def call
      @user = User.first(gid: @gid)
      return fail!(I18n.t(:user_not_found, scope: 'service.users.destroy_service')) if @user.blank?

      @user.destroy
    end
  end
end
