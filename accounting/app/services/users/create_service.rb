# frozen_string_literal: true

module Users
  class CreateService
    prepend BasicService

    param :gid
    param :role

    attr_reader :user

    def call
      @user = ::User.new(gid: @gid, role: @role, balance: Balance::INITIAL_VALUE)

      @user.valid? ? @user.save : fail!(@user.errors)
    end
  end
end
