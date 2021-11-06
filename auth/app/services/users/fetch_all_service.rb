# frozen_string_literal: true

module Users
  class FetchAllService
    prepend BasicService

    param :gid

    attr_reader :users

    def call
      if @gid.blank? || session.blank?
        return fail!(I18n.t(:unauthenticated, scope: 'errors'))
      end

      @users = User.reverse_order(:updated_at)
    end

    private

    def session
      @session ||= UserSession.find(gid: @gid)
    end
  end
end
