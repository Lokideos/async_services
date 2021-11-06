# frozen_string_literal: true

module Users
  class CreateService
    prepend BasicService

    param :name
    param :email
    param :role
    param :password

    attr_reader :user

    def call
      @user = ::User.new(name: @name, email: @email, role: @role, password: @password)

      @user.valid? ? @user.save : fail!(@user.errors)
    end
  end
end
